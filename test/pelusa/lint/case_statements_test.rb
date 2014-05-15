require 'test_helper'

module Pelusa
  module Lint
    describe CaseStatements do
      before do
        @lint = CaseStatements.new
      end

      describe '#check' do
        describe 'when the class does not use switch statements' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                return nil
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class uses case statements' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                case foo
                  when bar
                end
              end
            end"""

            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end
      end
    end
  end
end
