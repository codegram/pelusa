require 'test_helper'

module Pelusa
  describe Analyzer do
    describe '#analyze' do
      before do
        @ast      = "123".to_ast
        @reporter = stub report: "foo"
        @analyzer = Analyzer.new(@ast, @reporter)
      end

      it 'analyzes an ast' do
        @analyzer.analyze
      end
    end
  end
end
