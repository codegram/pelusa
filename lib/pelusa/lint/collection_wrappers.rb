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
        array_assignments = {}

        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::AST::InstanceVariableAssignment)
            # if it's an instance variable assignment, it's a violation
            # unless it's an array assignment
            if (node.value.is_a?(Rubinius::AST::ArrayLiteral) ||
              node.value.is_a?(Rubinius::AST::EmptyArray))
              array_assignments[node.name] = true
            else
              @violations << node.line
            end
          elsif node.is_a?(Rubinius::AST::InstanceVariableAccess) &&
              !array_assignments[node.name]
            @violations << node.line
          end
        end
      end
    end
  end
end
