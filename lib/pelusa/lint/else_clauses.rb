module Pelusa
  module Lint
    class ElseClauses
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "There are #{violations.length} else clauses in lines #{violations.to_a.join(', ')}"
        end
      end

      private

      def name
        "Doesn't use else clauses"
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::AST::If)
            has_body = node.body && !node.body.is_a?(Rubinius::AST::NilLiteral)
            has_else = node.else && !node.else.is_a?(Rubinius::AST::NilLiteral)

            if has_body && has_else
              @violations << node.else.line
            end
          end
        end
      end
    end
  end
end
