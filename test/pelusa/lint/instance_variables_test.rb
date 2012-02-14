require 'test_helper'

module Pelusa
  module Lint
    describe InstanceVariables do
      before do
        @lint = InstanceVariables.new
      end

      describe '#check' do
        describe 'when the class uses less than 3 ivars' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def initialize
                @foo = 1
                @bar = 2
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class has more than 50 lines' do
          it 'returns a FailureAnalysis' do
            klass = """
            class Foo
              def initialize
                @foo = 1
                @bar = 2
                @baz = 3
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end
      end
    end
  end
end
