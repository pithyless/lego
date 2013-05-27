require 'spec_helper'

describe 'Lego::Value' do

  let(:klass) do
    Class.new.tap do |obj|
      obj.send(:include, Lego::Value.new(:name, :age))
    end
  end

  subject { klass.new(name: 'Bob', age: 30) }

  context 'defaults attributes to nil' do
    subject { klass.new }

    its(:name) { should == nil }
    its(:age)  { should == nil }
  end

  context 'sets attributes' do
    its(:name) { should == 'Bob' }
    its(:age)  { should == 30 }
  end

  it 'compares itself' do
    obj = klass.new(name: 'Bob', age: 30)
    subject.should == obj
    subject.hash.should == obj.hash
    subject.should_not equal(obj)

    subject.should_not == klass.new(name: 'Bob', age: 40)
  end

end
