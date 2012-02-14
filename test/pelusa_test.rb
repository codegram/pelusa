require 'test_helper'

module Pelusa
  describe '.run' do
    describe 'without arguments' do
      before do
        @runner = mock
        @output = mock
      end

      it 'invokes a new Runner on all Ruby files' do
        Runner.expects(:new).with(Lint.all).returns @runner
        @runner.expects(:run).with(Dir["**/*.rb"]).returns @output

        Pelusa.run.must_equal @output
      end
    end
  end
end
