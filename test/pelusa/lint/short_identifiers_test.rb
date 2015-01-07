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
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                foo = 3
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class contains short identifier from reserved list' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                id = 2
                pp id
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class contains a short identifier' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                x = 2
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
