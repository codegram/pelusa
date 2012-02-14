require 'test_helper'

module Pelusa
  describe ClassAnalyzer do
    describe '#analyze' do
      before do
        @lints = [
          stub(new: stub(check: true)),
          stub(new: stub(check: true))
        ]
        @klass    = stub
        @analyzer = ClassAnalyzer.new(@klass)
      end

      it 'analyzes a Class node for a series of lints' do
        @analyzer.analyze(@lints).must_equal [true, true]
      end
    end
  end
end
