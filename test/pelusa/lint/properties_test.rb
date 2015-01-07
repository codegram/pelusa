require 'test_helper'

module Pelusa
  module Lint
    describe Properties do
      before do
        @lint = Properties.new
      end

      describe '#check' do
        describe 'when the class does not use getters, setters or properties' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                @name = 'john'
              end

              def name
                @name
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class uses getters, setters or properties' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              attr_accessor :name
              attr_reader :foo
            end"""

            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end
      end
    end
  end
end
