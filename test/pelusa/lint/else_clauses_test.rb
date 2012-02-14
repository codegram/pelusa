require 'test_helper'

module Pelusa
  module Lint
    describe ElseClauses do
      before do
        @lint = ElseClauses.new
      end

      describe '#check' do
        describe 'when the class does not use else clauses' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def initialize
                if 3
                  8
                end
                unless 9
                  3
                end
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class uses else clauses' do
          it 'returns a FailureAnalysis' do
            klass = """
            class Foo
              def initialize
                if 3
                  8
                else
                  9
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
