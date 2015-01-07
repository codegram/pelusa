require 'test_helper'

module Pelusa
  module Lint
    describe ManyArguments do
      before do
        @lint = ManyArguments.new
      end

      describe '#check' do
        describe 'when the class contains only method definitions with a small number of arguments' do
          it 'returns a SuccessAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def bar(dog)
                return dog
              end
              def baz(dog, cat)
                return dog + cat
              end
              def bam(dog, cat, fish)
                return dog + cat + fish
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class contains a method definition with many arguments' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def bar(dog, cat, fish, lobster)
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
