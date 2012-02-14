require 'test_helper'

module Pelusa
  describe Runner do
    describe '#run' do
      before do
        @report = stub(empty?: false, report: true)
        analyzer = stub(:analyze => @report)
        Analyzer.stubs(:new).returns analyzer
      end

      it 'runs a single file' do
        Pelusa.run(__FILE__).must_equal [true]
      end

      it 'runs multiple files' do
        Pelusa.run([__FILE__, __FILE__]).must_equal [true, true]
      end
    end
  end
end
