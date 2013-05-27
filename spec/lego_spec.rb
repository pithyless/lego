require 'spec_helper'

describe Lego do
  let(:value) { double }

  it '::left' do
    Lego.left(value).should == Lego::Left.new(value)
  end

  it '::right' do
    Lego.right(value).should == Lego::Right.new(value)
  end
end
