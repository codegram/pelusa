require 'test_helper'

module Pelusa
  describe Analyzer do
    describe '#analyze' do
      describe 'with a multi-expression AST' do
        before do
          @ast = Pelusa.to_ast """
            class Foo
              def bar
                123
              end
            end

            class Bar
              def baz
                321
              end
            end

            module Baz
              def bar
                2.7
              end
            end
          """

          lints = stub
          @analyzer = Analyzer.new([Lint::LineRestriction], RubyReporter, "foo.rb")
        end

        it 'analyzes an ast and returns a report' do
          result = @analyzer.analyze(@ast).report
          result[:filename].must_equal "foo.rb"
          result[:Foo]["Is below 50 lines"][:status].must_equal "successful"
          result[:Bar]["Is below 50 lines"][:status].must_equal "successful"
          result[:Baz]["Is below 50 lines"][:status].must_equal "successful"
        end
      end

      describe 'with a single-expression AST' do
        before do
          @ast = Pelusa.to_ast """
            class Foo
              def bar
                123
              end
            end
          """

          lints = stub
          @analyzer = Analyzer.new([Lint::LineRestriction], RubyReporter, "foo.rb")
        end

        it 'analyzes an ast and returns a report' do
          result = @analyzer.analyze(@ast).report
          result[:filename].must_equal "foo.rb"
          result[:Foo]["Is below 50 lines"][:status].must_equal "successful"
        end
      end
    end
  end
end
