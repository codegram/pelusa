require 'test_helper'

module Pelusa
  module Lint
    describe CollectionWrappers do
      before do
        @lint = CollectionWrappers.new
      end

      describe '#check' do
        describe 'when the class is not a collection wrapper with more instance variables' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                @things = []
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class has no ivars' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                things = []
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class mixes collection ivars with others' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                @things = []
                @foo = 'bar'
              end
            end"""

            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end

        describe 'when the class has multiple array assignments' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                @things = []
                @foos = []
              end
            end"""

            analysis = @lint.check(klass)
            analysis.failed?.must_equal false
          end
        end

        describe 'when the class has multiple array and other assignments' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                @things = []
                @foos = []
                @foo = 'bar'
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
