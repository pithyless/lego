require 'spec_helper'

describe Lego do
  let(:value) { double }

  it '::pass' do
    Lego.pass(value).should == Lego::Success.new(value)
  end

  it '::fail' do
    Lego.fail(value).should == Lego::Failure.new(value)
  end
end
