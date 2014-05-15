module Pelusa
  module Lint
    class CaseStatements
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "There are #{violations.length} case statements in lines #{violations.to_a.join(', ')}"
        end
      end

      private

      def name
        "Doesn't use case statements"
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::ToolSets::Runtime::ToolSet::AST::Case)
            @violations << node.line
          end
        end
      end
    end
  end
end
