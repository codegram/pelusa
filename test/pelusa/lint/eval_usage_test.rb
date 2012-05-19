# encoding: utf-8
require 'test_helper'

module Pelusa
  module Lint
    describe EvalUsage do
      before { @lint = EvalUsage.new }

      describe '#check' do
        describe 'when class does not use eval statement' do
          it 'return successful analysis' do
            klass_str = <<RUBY
class WithoutEval
  def initialize
    @good = true
  end
end
RUBY
            klass = klass_str.to_ast
            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end

        describe 'when class use eval statement' do
          it 'return failed analysis' do
            klass_str = <<RUBY
class WithEval
  def initialize
    eval "@good = false"
  end
end
RUBY
            klass = klass_str.to_ast
            analysis = @lint.check(klass)
            analysis.failed?.must_equal true
          end
        end

        describe 'when class define method named eval' do
          it 'return successful analysis' do
            klass_str = <<RUBY
class WithEvalUse
  def initialize
    @other_obj = Object.new
    @other_obj.eval "boom"
  end
end
RUBY
            klass = klass_str.to_ast
            analysis = @lint.check(klass)
            analysis.successful?.must_equal true
          end
        end
      end
    end
  end
end