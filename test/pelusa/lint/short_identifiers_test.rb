require 'test_helper'

module Pelusa
  module Lint
    describe ShortIdentifiers do
      before do
        @lint = ShortIdentifiers.new
      end

      describe '#check' do
        describe 'when the class contains no short identifiers' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def initialize
                foo = 3
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class contains a short identifier' do
          it 'returns a FailureAnalysis' do
            klass = """
            class Foo
              def initialize
                x = 2
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
