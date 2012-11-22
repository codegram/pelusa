module Pelusa
  module Lint
    class ManyArguments
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, formatted_violations) do |violations|
          "Methods with more than #{limit} arguments: #{violations.join(', ')}"
        end
      end

      private

      def name
        "Methods have short argument lists"
      end

      def limit
        Pelusa.configuration['ManyArguments'].fetch('limit', 3)
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::AST::Define) && node.arguments.total_args > limit
            @violations << node.name
          end
        end
      end

      def formatted_violations
        @violations.to_a
      end
    end
  end
end
