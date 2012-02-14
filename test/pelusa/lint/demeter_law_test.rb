require 'test_helper'

module Pelusa
  module Lint
    describe DemeterLaw do
      before do
        @lint = DemeterLaw.new
      end

      describe '#check' do
        describe 'when the class respects Demeter law' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def initialize
                foo = 'hey'.upcase
                foo.downcase
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class does not respect Demeter law' do
          it 'returns a FailureAnalysis' do
            klass = """
            class Foo
              def initialize
                foo = 'hey'.upcase.downcase
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
