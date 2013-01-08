require 'spec_helper'

describe Legit::Model do

  class Person < Legit::Model
    attribute :name, :string
    attribute :age,  :string
  end

  class Family < Legit::Model
    attribute :last_name, :string
    attribute :father, Person
  end

  context 'Person' do
    subject do
      Person.new(name: 'Alice', age: '10')
    end

    it '::attributes' do
      Person.attribute_names.should == [:name, :age]
    end

    its(:name){ should == 'Alice' }
    its(:age){ should == '10' }

    it '#attributes' do
      subject.attributes.should == { name: 'Alice', age: '10' }
      subject.attributes.should be_frozen
    end

    it 'raises error on unknown attribute' do
      expect{ Person.new(name: 'Alice', age: '10', grade: 5) }.to raise_error(ArgumentError, "Unknown attributes: {:grade=>5}")
    end

    it 'fails on validation' do
      expect{ Person.new(name: 'Alice') }.to raise_error(ArgumentError, ":age => Missing required value")
      expect{ Person.new(name: 'Alice', age: Date.today) }.to raise_error(ArgumentError, /Not a string/)
    end
  end

  context 'equality' do
    it '#==' do
      Person.new(name: 'Alice', age: '10').should == Person.new(name: 'Alice', age: '10')
      Person.new(name: 'Alice', age: '10').should_not == Person.new(name: 'Bob', age: '10')
      Person.new(name: 'Alice', age: '10').should_not == Person.new(name: 'Alice', age: '12')
    end

    it '#eql?' do
      Person.new(name: 'Alice', age: '10').should eql Person.new(name: 'Alice', age: '10')
      Person.new(name: 'Alice', age: '10').should_not eql Person.new(name: 'Bob', age: '10')
      Person.new(name: 'Alice', age: '10').should_not eql Person.new(name: 'Alice', age: '12')
    end

    it '#hash' do
      Person.new(name: 'Alice', age: '10').hash.should == Person.new(name: 'Alice', age: '10').hash
      Person.new(name: 'Alice', age: '10').hash.should_not == Person.new(name: 'Bob', age: '10').hash
      Person.new(name: 'Alice', age: '10').hash.should_not == Person.new(name: 'Alice', age: '12').hash
    end
  end

  context 'Family' do
    it 'creates recursively from hash' do
      family = Family.new(last_name: 'Kowalski', father: { name: 'Bob', age: '55' })
      family.should be_instance_of(Family)
      family.last_name.should == 'Kowalski'
      family.father.should == Person.new(name: 'Bob', age: '55')
    end

    it 'creates from partial hash' do
      family = Family.new(last_name: 'Kowalski', father: Person.new(name: 'Bob', age: '55'))
      family.should be_instance_of(Family)
      family.last_name.should == 'Kowalski'
      family.father.should == Person.new(name: 'Bob', age: '55')
    end
  end

end
