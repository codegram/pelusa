require 'test_helper'

module Pelusa
  describe Lint do
    describe '#check' do
      before do
        @lint = Lint.new
        @klass = Class.new.to_ast
      end

      it 'checks for the compliance of a given class' do

      end
    end
  end
end
