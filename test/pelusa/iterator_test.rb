require 'test_helper'

module Pelusa
  describe Iterator do
    before do
      @last_node = nil
      @iterator  = Iterator.new do |node|
        @last_node = node if node == 3
      end

      @node = [ [ 1, [ 2, 3 ] ] ]
    end

    describe '#call' do
      it 'calls the iterator on a node' do
        @iterator.call(@node)
        @last_node.must_equal 3
      end
    end

    describe '#to_proc' do
      it 'calls the iterator on a node' do
        @iterator.to_proc[@node]
        @last_node.must_equal 3
      end
    end
  end
end
