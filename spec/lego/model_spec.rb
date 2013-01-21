require 'spec_helper'
require 'date'

describe Lego::Model do

  class Person < Lego::Model
    attribute :name, String
    attribute :age,  Integer
  end

  class Family < Lego::Model
    attribute :last_name, String
    attribute :father, Person
  end

  context 'Person' do
    subject do
      Person.coerce(name: 'Alice', age: '10')
    end

    it '::attributes' do
      Person.attribute_names.should == [:name, :age]
    end

    its(:name){ should == 'Alice' }
    its(:age){ should == 10 }

    it '#attributes' do
      subject.attributes.should == { name: 'Alice', age: 10 }
      subject.attributes.should be_frozen
    end

    it 'raises error on unknown attribute' do
      expect{ Person.coerce(name: 'Alice', age: '10', grade: 5) }.to raise_error(ArgumentError, "Unknown attributes: {:grade=>5}")
    end

    it 'fails on validation' do
      expect{ Person.coerce(name: 'Alice') }.to raise_error(Lego::Model::ParseError, '{:age=>"missing value"}')
      expect{ Person.coerce(name: 'Alice', age: Date.today) }.to raise_error(Lego::Model::ParseError, /invalid integer/)
    end

    it 'stores errors as hash' do
      begin
        Person.coerce(name: 'Alice')
      rescue => e
        e.errors.should == { age: 'missing value' }
      end
    end

    it 'fails on non-hash initialize' do
      expect{ Person.coerce(nil) }.to raise_error(ArgumentError, "attrs must be hash: 'nil'")
    end

    it 'dupes attributes' do
      h = { name: 'Alice', age: 10 }
      Person.coerce(h)
      h.should == { name: 'Alice', age: 10 }
    end
  end

  context 'equality' do
    it '#==' do
      Person.coerce(name: 'Alice', age: 10).should == Person.coerce(name: 'Alice', age: '10')
      Person.coerce(name: 'Alice', age: 10).should_not == Person.coerce(name: 'Bob', age: '10')
      Person.coerce(name: 'Alice', age: 10).should_not == Person.coerce(name: 'Alice', age: '12')
    end

    it '#eql?' do
      Person.coerce(name: 'Alice', age: 10).should eql Person.coerce(name: 'Alice', age: '10')
      Person.coerce(name: 'Alice', age: 10).should_not eql Person.coerce(name: 'Bob', age: '10')
      Person.coerce(name: 'Alice', age: 10).should_not eql Person.coerce(name: 'Alice', age: '12')
    end

    it '#hash' do
      Person.coerce(name: 'Alice', age: 10).hash.should == Person.coerce(name: 'Alice', age: '10').hash
      Person.coerce(name: 'Alice', age: 10).hash.should_not == Person.coerce(name: 'Bob', age: '10').hash
      Person.coerce(name: 'Alice', age: 10).hash.should_not == Person.coerce(name: 'Alice', age: '12').hash
    end
  end

  context 'Family' do
    it 'creates recursively from hash' do
      family = Family.coerce(last_name: 'Kowalski', father: { name: 'Bob', age: '55' })
      family.should be_instance_of(Family)
      family.last_name.should == 'Kowalski'
      family.father.should == Person.coerce(name: 'Bob', age: '55')
    end

    it 'creates from partial hash' do
      family = Family.coerce(last_name: 'Kowalski', father: Person.coerce(name: 'Bob', age: '55'))
      family.should be_instance_of(Family)
      family.last_name.should == 'Kowalski'
      family.father.should == Person.coerce(name: 'Bob', age: '55')
    end

    it 'initializes from string keys' do
      family = Family.coerce('last_name' => 'Kowalski', 'father' => Person.coerce('name' => 'Bob', 'age' => '55'))
      family.should be_instance_of(Family)
      family.last_name.should == 'Kowalski'
      family.father.should == Person.coerce(name: 'Bob', age: '55')
    end
  end


  describe '#as_json' do
    it 'serializes Family' do
      family = Family.coerce(last_name: 'Kowalski', father: { name: 'Bob', age: '55' })
      family.as_json.should == {
        :last_name => "Kowalski",
        :father => {
          :name => "Bob",
          :age => 55
        }
      }
    end
  end

  describe '#merge' do
    let(:one) { Family.coerce(last_name: 'Kowalski', father: { name: 'Bob', age: '55' }) }

    it 'returns new object' do
      two = one.merge({})
      two.should == one
      two.should_not equal(one)
    end

    it 'merges changes' do
      two = one.merge(last_name: 'Tesla', father: { name: 'Nikola' })

      one.should == Family.coerce(last_name: 'Kowalski', father: { name: 'Bob', age: '55' })
      two.should == Family.coerce(last_name: 'Tesla', father: { name: 'Nikola', age: '55' })
    end
  end

  describe '::validates' do
    let(:today) { Date.today }

    it 'runs validations after coercions' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates :start do |o| o.start < o.stop ? Lego.just(o) : Lego.fail('must start before end') end
      end

      klass.parse(start: today.to_s, stop: today).should be_error({start: 'must start before end'})
    end

    it 'validates via block' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates :start do |o| o.start < o.stop ? Lego.just(o) : Lego.fail('must start before end') end
        validates :start do |o| (o.start + 2) < o.stop ? Lego.just(o) : Lego.fail('at least 3 days after') end
      end

      klass.parse(start: today.to_s, stop: today.to_s).should be_error(start: 'must start before end')
      klass.parse(start: today.to_s, stop: (today + 2).to_s).should be_error(start: 'at least 3 days after')
      klass.parse(start: today.to_s, stop: (today + 3).to_s).should be_value
    end


    it 'validates until first error in each attribute' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates :start do |o| o.start < o.stop ? Lego.just(o) : Lego.fail('must start before end') end
        validates :start do |o| fail 'Should NOT EXECUTE' end
        validates :stop  do |o| o.stop > o.start + 1 ? Lego.just(o) : Lego.fail('must stop after at least 3 days') end
      end

      klass.parse(start: today, stop: today).should be_error(start: 'must start before end', stop: 'must stop after at least 3 days')
    end


    it 'validates via instance method' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates :start, :check_start_before_end
        validates :start, :check_at_least_3_days

        def check_start_before_end
          start < stop ? Lego.just(self) : Lego.fail('must start before end')
        end

        def check_at_least_3_days
          (start + 2) < stop ? Lego.just(self) : Lego.fail('at least 3 days after')
        end
      end

      klass.parse(start: today.to_s, stop: today.to_s).should be_error(start: 'must start before end')
      klass.parse(start: today.to_s, stop: (today + 2).to_s).should be_error(start: 'at least 3 days after')
      klass.parse(start: today.to_s, stop: (today + 3).to_s).should be_value
    end
  end

  it 'correctly handles array values' do
    klass = Class.new(Lego::Model) do
      attribute :nums, Array, Integer, length: 2
    end

    klass.parse(nums: [1,2]).should be_value
    klass.parse(nums: [1,2,3,4]).should be_error(nums: "length not 2: '[1, 2, 3, 4]'")
  end

end
