require 'test_helper'

module Pelusa
  describe Analyzer do
    describe '#analyze' do
      before do
        @ast      = """
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
        """.to_ast

        @reporter = Struct.new(:results)
        lints = stub
        @analyzer = Analyzer.new(lints, @reporter)
      end

      it 'analyzes an ast and returns a report' do
        class_analyzer = stub(analyze: 'result')
        ClassAnalyzer.stubs(:new).returns class_analyzer

        @analyzer.analyze(@ast).results.must_equal ['result', 'result']
      end
    end
  end
end
