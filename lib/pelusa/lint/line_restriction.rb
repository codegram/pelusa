module Pelusa
  module Lint
    class LineRestriction
      def initialize
        @lines = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if lines < limit

        FailedAnalysis.new(name, lines) do |lines|
          "This class has #{lines} lines."
        end
      end

      private

      def name
        "Is below #{limit} lines"
      end

      def limit
        Pelusa.configuration['LineRestriction'].fetch('limit', 50)
      end

      def lines
        @lines.max - @lines.min
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          @lines << node.line if node.respond_to?(:line)
        end
      end
    end
  end
end
