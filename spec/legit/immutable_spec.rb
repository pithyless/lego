require 'spec_helper'

describe Legit::Immutable do

  class Person < Legit::Immutable
    attributes :name, :age
  end

  subject do
    Person.new(name: 'Alice', age: 10)
  end

  it '::attributes' do
    Person.attribute_names.should == [:age, :name]
    Person.attribute_names.should be_frozen
  end

  its(:name){ should == 'Alice' }
  its(:age){ should == 10 }

  it '#attributes' do
    subject.attributes.should == { age: 10, name: 'Alice' }
    subject.attributes.should be_frozen
  end

  it 'ignores other attributes' do
    [ Person.new(name: 'Alice', grade: 5),
      Person.new(name: 'Alice'),
      Person.new(name: 'Alice', age: nil) ].uniq.length.should == 1
  end

  context 'equality' do
    it '#==' do
      Person.new(name: 'Alice', age: 10).should == Person.new(name: 'Alice', age: 10)
      Person.new(name: 'Alice', age: 10).should_not == Person.new(name: nil, age: 10)
      Person.new(name: 'Alice', age: 10).should_not == Person.new(name: 'Alice', age: 12)
    end

    it '#eql?' do
      Person.new(name: 'Alice', age: 10).should eql Person.new(name: 'Alice', age: 10)
      Person.new(name: 'Alice', age: 10).should_not eql Person.new(name: nil, age: 10)
      Person.new(name: 'Alice', age: 10).should_not eql Person.new(name: 'Alice', age: 12)
    end

    it '#hash' do
      Person.new(name: 'Alice', age: 10).hash.should == Person.new(name: 'Alice', age: 10).hash
      Person.new(name: 'Alice', age: 10).hash.should_not == Person.new(name: nil, age: 10).hash
      Person.new(name: 'Alice', age: 10).hash.should_not == Person.new(name: 'Alice', age: 12).hash
    end
  end

end
