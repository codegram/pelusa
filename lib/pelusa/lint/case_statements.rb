module Pelusa
  module Lint
    class CaseStatements
      def initialize
        @violations = Set.new
      end

      def check(klass)
        initialize
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
        iterator = Iterator.new do |node|
          if node.is_a?(Rubinius::AST::Case)
            @violations << node.line
          end
        end
        Array(klass).each(&iterator)
      end
    end
  end
end
