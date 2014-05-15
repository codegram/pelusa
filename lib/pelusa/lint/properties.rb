module Pelusa
  module Lint
    class Properties
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "There are getters, setters or properties in lines #{violations.to_a.join(', ')}"
        end
      end

      private

      def name
        "Doesn't use getters, setters or properties"
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          if node.is_a?(Rubinius::ToolSets::Runtime::ToolSet::AST::Send)
            if [:attr_accessor, :attr_writer, :attr_reader].include? node.name
              @violations << node.line
            end
          end
        end
      end
    end
  end
end
