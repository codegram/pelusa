require 'test_helper'

module Pelusa
  module Lint
    describe LineRestriction do
      before do
        @lint = LineRestriction.new
      end

      describe '#check' do
        describe 'when the class has less than 50 lines' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              attr_accessor :foo
              attr_accessor :bar
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class has more than 50 lines' do
          it 'returns a FailureAnalysis' do
            klass = """
            class Foo
              attr_accessor :foo
              #{"\n" * 80}
              attr_accessor :bar
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end
      end
    end
  end
end
