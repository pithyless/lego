require 'spec_helper'

describe Lego::Right do

  let(:value) { double }
  subject { Lego::Right.new(value) }

  its(:left?)  { should == false }
  its(:right?) { should == true }

  it 'returns value for #right' do
    subject.right.should == value
  end

  it 'fails for #left' do
    expect{ subject.left }.to raise_error(NoMethodError)
  end

end
