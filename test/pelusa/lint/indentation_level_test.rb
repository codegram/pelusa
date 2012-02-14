require 'test_helper'

module Pelusa
  module Lint
    describe IndentationLevel do
      before do
        @lint = IndentationLevel.new
      end

      describe '#check' do
        describe 'when the class has one method with one or less indentation levels' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def initialize
                if 9
                  3
                end
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class has one method with more than one indentation level' do
          it 'returns a FailureAnalysis' do
            klass = """
            class Foo
              def initialize
                if 9
                  unless 3
                    5
                  end
                end
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
