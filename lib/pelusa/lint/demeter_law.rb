module Pelusa
  module Lint
    class DemeterLaw
      def initialize
        @violations = Set.new
      end

      def check(klass)
        initialize
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "There are #{violations.length} Demeter law violations in lines #{violations.to_a.join(', ')}."
        end
      end

      private

      def name
        "Respects Demeter law"
      end

      def iterate_lines!(klass)
        iterator = Iterator.new do |node|
          if node.is_a?(Rubinius::AST::Send) && node.receiver.is_a?(Rubinius::AST::Send)
            @violations << node.line unless white_listed?(node.receiver.name)
          end
        end
        Array(klass).each(&iterator)
      end

      def white_listed? method
        [Class, Fixnum, Enumerable].any? do |enclosing_module|
          enclosing_module.instance_methods.any? {|instance_method| instance_method == method }
        end
      end
    end
  end
end
