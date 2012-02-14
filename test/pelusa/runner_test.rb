require 'test_helper'

module Pelusa
  describe Runner do
    describe '#run' do
      before do
        @report = stub(empty?: false, report: true)
        analyzer = stub(:analyze => @report)
        Analyzer.stubs(:new).returns analyzer
      end

      describe 'when the reports are successful' do
        it 'returns 0' do
          @report.stubs(successful?: true)
          Pelusa.run(__FILE__).must_equal 0
        end
      end

      describe 'when the reports have failed' do
        it 'returns 1' do
          @report.stubs(successful?: false)
          Pelusa.run(__FILE__).must_equal 1
        end
      end
    end
  end
end
