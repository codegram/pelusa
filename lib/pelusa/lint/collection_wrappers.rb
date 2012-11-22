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
        # the array of actual assignment nodes -- we only want to assign once
        array_assignments = {}
        # the name of all the assigned arrays, no others allowed
        array_values = {}

        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::AST::InstanceVariableAssignment) &&
            (node.value.is_a?(Rubinius::AST::ArrayLiteral) ||
             node.value.is_a?(Rubinius::AST::EmptyArray))
            array_assignments[node] = true
            array_values[node.name] = true
          end
        end

        unless array_assignments.empty?
          ClassAnalyzer.walk(klass) do |node|
            # if this is where we assign the node for the first time, good
            unless array_assignments[node]
              # otherwise, if it's an instance variable assignment, verboten!
              if node.is_a?(Rubinius::AST::InstanceVariableAssignment)
                @violations << node.line
              # or if we access any other ivars
              elsif node.is_a?(Rubinius::AST::InstanceVariableAccess) &&
                !array_values[node.name]
                @violations << node.line
              end
            end
          end
        end
      end
    end
  end
end
