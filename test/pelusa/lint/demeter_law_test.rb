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

        describe 'when chaining whitelisted operations' do
          it 'returns a SuccessAnalysis for chained operations from Enumerable' do
            klass = """
            class Foo
              def execute
                [1,2,3].map(&:object_id).each {|i| i}
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end

          it 'returns a SuccessAnalysis when chaining methods from Fixnum' do
            klass = """
            class Foo
              def execute
                1 + 2 + 3 + 4
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end

          it 'returns a SuccessAnalysis for chained operations from Object' do
            klass = """
            class Foo
              def execute
                Object.new.to_s.inspect
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end

          it 'returns a SuccessAnalysis for chained operations from optional sources' do
            Pelusa.configuration.stubs(:[]).with("DemeterLaw").returns(
              {"whitelist" => "Object, Kernel, Hash, Enumerable"}
            )

            klass = """
            class Foo
              def execute
                {'a' => 2}.merge.each_pair {|k, v|}
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'conversions' do
          it 'returns a SuccessAnalysis for conversion operations if allowed' do
            Pelusa.configuration.stubs(:[]).with("DemeterLaw").returns(
              {"allow_conversions" => true}
            )

            klass = """
            class Foo
              def execute
                {'a' => 2}.merge({}).to_hash.as_json
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end

          it 'returns a FailureAnalysis for conversions if not allowed' do
            klass = """
            class Foo
              def execute
                {'a' => 2}.merge({}).to_hash
              end
            end""".to_ast

            analysis = @lint.check(klass)
            analysis.successful?.must_equal false
          end
        end
      end
    end
  end
end
