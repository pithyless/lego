require 'spec_helper'

describe Lego::Struct do

  let(:klass) do
    Lego::Struct.new(:name, :age)
  end

  subject { klass.new(name: 'Bob', age: 30) }

  context 'initialize with attributes' do
    its(:name) { should == 'Bob' }
    its(:age)  { should == 30 }
  end

  context 'initialize with defaults' do
    subject { klass.new }

    its(:name) { should == nil }
    its(:age)  { should == nil }
  end

  it '#to_h' do
    obj = klass.new(name: 'Bob', age: 30)
    obj.to_h.should == { name: 'Bob', age: 30 }
  end

  it '::attributes' do
    klass.attributes.should == [:age, :name]
  end

  it 'compares itself' do
    obj = klass.new(name: 'Bob', age: 30)
    subject.should eql(obj)
    subject.should == obj
    subject.hash.should == obj.hash
    subject.should_not equal(obj)

    subject.should_not == klass.new(name: 'Bob', age: 40)
  end

  context 'nil is equal to not-initialized' do
    subject { klass.new }

    it 'compares itself when nil' do
      obj = klass.new(name: nil, age: nil)
      subject.should eql(obj)
      subject.should == obj
      subject.hash.should == obj.hash
      subject.should_not equal(obj)

      subject.should_not == klass.new(name: 'Bob')
    end
  end

end
