require 'test_helper'

module Pelusa
  describe SuccessfulAnalysis do
    before do
      @analysis = SuccessfulAnalysis.new("Is awesome")
    end

    it 'is successful' do
      @analysis.successful?.must_equal true
    end

    describe '#message' do
      it 'has an empty message' do
        @analysis.message.empty?.must_equal true
      end
    end
  end

  describe FailedAnalysis do
    before do
      number_of_errors = 42
      @analysis = FailedAnalysis.new("Is awesome", number_of_errors) do |errors|
        "There have been #{errors} errors."
      end
    end

    it 'is failed' do
      @analysis.failed?.must_equal true
    end

    describe '#message' do
      it 'describes the failed analysis' do
        @analysis.message.must_equal "There have been 42 errors."
      end
    end
  end
end
