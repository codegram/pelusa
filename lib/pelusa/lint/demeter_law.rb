module Pelusa
  module Lint
    class DemeterLaw
      def initialize
        @violations = Set.new
      end

      def check(klass)
        initialize
        iterate_lines!(klass)

        if @violations.empty?
          SuccessfulAnalysis.new(name)
        else
          FailedAnalysis.new(name, @violations) do |violations|
            "There are #{violations.length} Demeter law violations in lines #{violations.to_a.join(', ')}."
          end
        end
      end

      private

      def name
        "Respects Demeter law"
      end

      def iterate_lines!(klass)
        iterator = Iterator.new do |node|
          if node.is_a?(Rubinius::AST::Send) && node.receiver.is_a?(Rubinius::AST::Send)
            @violations << node.line
          end
        end
        Array(klass).each(&iterator)
      end
    end
  end
end
