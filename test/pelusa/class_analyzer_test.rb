require 'test_helper'

module Pelusa
  describe ClassAnalyzer do
    describe '#analyze' do
      before do
        @lints = [
          stub(new: stub(check: true)),
          stub(new: stub(check: true))
        ]
        @klass    = stub(name: stub(name: "Foo"))
        @analyzer = ClassAnalyzer.new(@klass)
      end

      it 'analyzes a Class node for a series of lints' do
        @analyzer.analyze(@lints).must_equal [true, true]
      end

      describe '#class_name' do
        it 'returns the name of the analyzed class' do
          @analyzer.class_name.must_equal "Foo"
        end
      end

      describe "#type" do
        it "returns the type module for modules" do
          # hacky!
          @klass.stubs(:is_a?).with(Rubinius::ToolSets::Runtime::ToolSet::AST::Class).returns(true)
          @analyzer.type.must_equal "class"
        end

        it "returns the type module for modules" do
          # hacky!
          @klass.stubs(:is_a?).with(Rubinius::ToolSets::Runtime::ToolSet::AST::Class).returns(false)
          @analyzer.type.must_equal "module"
        end
      end
    end
  end
end
