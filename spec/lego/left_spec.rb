require 'spec_helper'

describe Lego::Left do

  let(:value) { double }
  subject { Lego::Left.new(value) }

  its(:left?)  { should == true }
  its(:right?) { should == false }

  it 'returns value for #left' do
    subject.left.should == value
  end

  it 'fails for #right' do
    expect{ subject.right }.to raise_error(NoMethodError)
  end

  it 'compares itself' do
    subject.should == Lego::Left.new(value)
  end

end
