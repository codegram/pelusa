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
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                if 9
                  3
                end
              end
            end"""

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when the class has one method with more than one indentation level' do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                if 9
                  unless 3
                    5
                  end
                end
              end
            end"""

            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end

        describe "when there is method which produces nested list" do
          it 'returns a FailureAnalysis' do
            klass = Pelusa.to_ast """
            class Foo
              def initialize
                if test
                  a = [
                    (1..3).map do |num|
                      num
                    end
                  ]
                end
              end
            end"""

            analysis = @lint.check klass
            analysis.failed?.must_equal true
          end
        end
      end
    end
  end
end
