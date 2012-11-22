module Pelusa
  module Lint
    class CollectionWrappers
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "Using an instance variable apart from the array ivar in lines #{violations.to_a.join(', ')}"
        end
      end

      private

      def name
        "Doesn't mix array instance variables with others"
      end

      def iterate_lines!(klass)
        array_assignment = nil

        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::AST::InstanceVariableAssignment) &&
            (node.value.is_a?(Rubinius::AST::ArrayLiteral) ||
             node.value.is_a?(Rubinius::AST::EmptyArray))
            array_assignment = node
          end
        end

        if array_assignment
          ClassAnalyzer.walk(klass) do |node|
            unless node == array_assignment
              if node.is_a?(Rubinius::AST::InstanceVariableAssignment)
                @violations << node.line
              elsif node.is_a?(Rubinius::AST::InstanceVariableAccess) && node.name != array_assignment.name
                @violations << node.line
              end
            end
          end
        end
      end
    end
  end
end
