# encoding: utf-8

module Pelusa
  module Lint
    class EvalUsage
      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        if @violations.empty?
          SuccessfulAnalysis.new(name)
        else
          FailedAnalysis.new(name, @violations) do |violations|
            "There are #{violations.length} eval statement in lines #{violations.to_a.join(', ')}"
          end
        end
      end

      private

      def name
        "Doesn't use eval statement"
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          @violations << node.line if eval_violation?(node)
        end
      end

      def eval_violation?(node)
        node.is_a?(Rubinius::AST::SendWithArguments) && node.name == :eval && node.receiver.is_a?(Rubinius::AST::Self)
      end

    end
  end
end