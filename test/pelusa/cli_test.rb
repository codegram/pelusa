require 'test_helper'

module Pelusa
  describe Cli do
    describe "#run" do
      before do
        @report = stub(empty?: false, report: true, class: Reporter)
        Pelusa.stubs(:run).returns [@report]
      end
      describe 'when the reports are successful' do
        it 'returns 0' do
          @report.stubs(successful?: true)
          Cli.new.run().must_equal 0
        end
      end
      describe 'when the reports have failed' do
        it 'returns 1' do
          @report.stubs(successful?: false)
          Cli.new.run().must_equal 1
        end
      end
    end
  end
end