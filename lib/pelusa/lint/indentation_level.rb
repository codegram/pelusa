module Pelusa
  module Lint
    class IndentationLevel
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "There's too much indentation in lines #{violations.to_a.join(', ')}."
        end
      end

      private

      def name
        "Doesn't use more than one indentation level inside methods"
      end

      def iterate_lines!(klass)
        # we want to find all nodes inside define blocks that
        # contain > 1 indentation levels
        # this method totally fails the IndentationLevel level lint :P
        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::AST::Define)
            # we're inside a method body, so see if we indent anywhere
            ClassAnalyzer.walk(node) do |inner_node|
              if inner_body = get_body_from_node[inner_node]
                # if it turns out there's an indented value in there, that
                # could be okay -- walk that node to see if there's a 2nd level
                if inner_node.line != [inner_body].flatten.first.line
                  # walk the third level, see if there's another indent
                  ClassAnalyzer.walk(inner_node) do |innermost_node|
                    if innermost_body = get_body_from_node[innermost_node]
                      if innermost_node.line != [innermost_body].flatten.first.line
                        # there's yet another level of indent -- violation!
                        # note: this also catches bad outdents, possibly should
                        # flag those separately
                        @violations.merge Array(innermost_body).map(&:line)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def get_body_from_node
        lambda do |node|
          if node.respond_to?(:body) && !node.body.is_a?(Rubinius::AST::NilLiteral)
             node.body
          elsif node.respond_to?(:else)
             node.else
          end
        end
      end
    end
  end
end
