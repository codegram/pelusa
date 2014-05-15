require 'test_helper'

module Pelusa
  module Lint
    describe LongIdentifiers do
      before do
        @lint = LongIdentifiers.new
      end

      describe '#check' do
        describe 'when the class contains no long identifiers' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                not_long_identifier = nil
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class contains a long identifier' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                it_is_long_identifier = nil
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
