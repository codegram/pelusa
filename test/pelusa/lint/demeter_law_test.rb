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

        describe 'when instantiating a class' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def execute
                Bar.new.execute
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true              
          end
        end

        describe 'when chaining operations on an Enumerable' do
          it 'returns a SuccessAnalysis' do
            klass = """
            class Foo
              def execute
                [1,2,3].map(&:object_id).map(&:object_id)
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true              
          end
        end
      end

      describe 'when chaining Fixnum operations' do
        it 'returns a SuccessAnalysis' do
          klass = """
          class Foo
            def execute
              1 + 2 + 3 + 4
            end
          end""".to_ast

          analysis = @lint.check(klass)
          analysis.successful?.must_equal true              
        end
      end
    end
  end
end
