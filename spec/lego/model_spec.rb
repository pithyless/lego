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
      Person.new(name: 'Alice', age: '10')
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
      expect{ Person.new(name: 'Alice', age: '10', grade: 5) }.to raise_error(ArgumentError, "Unknown attributes: {:grade=>5}")
    end

    it 'fails on validation' do
      expect{ Person.new(name: 'Alice') }.to raise_error(ArgumentError, ":age => missing value")
      expect{ Person.new(name: 'Alice', age: Date.today) }.to raise_error(ArgumentError, /invalid integer/)
    end

    it 'fails on non-hash initialize' do
      expect{ Person.new(nil) }.to raise_error(ArgumentError, "attrs must be hash: 'nil'")
    end

    it 'dupes attributes' do
      h = { name: 'Alice', age: 10 }
      Person.new(h)
      h.should == { name: 'Alice', age: 10 }
    end
  end

  context 'equality' do
    it '#==' do
      Person.new(name: 'Alice', age: 10).should == Person.new(name: 'Alice', age: '10')
      Person.new(name: 'Alice', age: 10).should_not == Person.new(name: 'Bob', age: '10')
      Person.new(name: 'Alice', age: 10).should_not == Person.new(name: 'Alice', age: '12')
    end

    it '#eql?' do
      Person.new(name: 'Alice', age: 10).should eql Person.new(name: 'Alice', age: '10')
      Person.new(name: 'Alice', age: 10).should_not eql Person.new(name: 'Bob', age: '10')
      Person.new(name: 'Alice', age: 10).should_not eql Person.new(name: 'Alice', age: '12')
    end

    it '#hash' do
      Person.new(name: 'Alice', age: 10).hash.should == Person.new(name: 'Alice', age: '10').hash
      Person.new(name: 'Alice', age: 10).hash.should_not == Person.new(name: 'Bob', age: '10').hash
      Person.new(name: 'Alice', age: 10).hash.should_not == Person.new(name: 'Alice', age: '12').hash
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

    it 'initializes from string keys' do
      family = Family.new('last_name' => 'Kowalski', 'father' => Person.new('name' => 'Bob', 'age' => '55'))
      family.should be_instance_of(Family)
      family.last_name.should == 'Kowalski'
      family.father.should == Person.new(name: 'Bob', age: '55')
    end
  end


  describe '#as_json' do
    it 'serializes Family' do
      family = Family.new(last_name: 'Kowalski', father: { name: 'Bob', age: '55' })
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
    let(:one) { Family.new(last_name: 'Kowalski', father: { name: 'Bob', age: '55' }) }

    it 'returns new object' do
      two = one.merge({})
      two.should == one
      two.should_not equal(one)
    end

    it 'merges changes' do
      two = one.merge(last_name: 'Tesla', father: { name: 'Nikola' })

      one.should == Family.new(last_name: 'Kowalski', father: { name: 'Bob', age: '55' })
      two.should == Family.new(last_name: 'Tesla', father: { name: 'Nikola', age: '55' })
    end
  end

  describe '::validates' do
    let(:today) { Date.today }

    it 'runs validations after coercions' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates { |o| o.start < o.stop ? Lego.just(o) : Lego.fail('must start before end') }
      end

      klass.parse(start: today.to_s, stop: today).should be_error('must start before end')
    end

    it 'validates via block' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates { |o| o.start < o.stop ? Lego.just(o) : Lego.fail('must start before end') }
        validates { |o| (o.start + 2) < o.stop ? Lego.just(o) : Lego.fail('at least 3 days after') }
      end

      klass.parse(start: today.to_s, stop: today.to_s).should be_error('must start before end')
      klass.parse(start: today.to_s, stop: (today + 2).to_s).should be_error('at least 3 days after')
      klass.parse(start: today.to_s, stop: (today + 3).to_s).should be_value
    end

    it 'validates via instance method' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validates :check_start_before_end
        validates :check_at_least_3_days

        def check_start_before_end
          start < stop ? Lego.just(self) : Lego.fail('must start before end')
        end

        def check_at_least_3_days
          (start + 2) < stop ? Lego.just(self) : Lego.fail('at least 3 days after')
        end
      end

      klass.parse(start: today.to_s, stop: today.to_s).should be_error('must start before end')
      klass.parse(start: today.to_s, stop: (today + 2).to_s).should be_error('at least 3 days after')
      klass.parse(start: today.to_s, stop: (today + 3).to_s).should be_value
    end
  end


  describe '::validate' do
    let(:today) { Date.today }

    it 'validate via message and boolean callable' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date

        validate 'must start before end', ->(o){ o.start < o.stop }
        validate 'at least 3 days after', ->(o){ (o.start + 2) < o.stop }
      end

      klass.parse(start: today.to_s, stop: today.to_s).should be_error('must start before end')
      klass.parse(start: today.to_s, stop: (today + 2).to_s).should be_error('at least 3 days after')
      klass.parse(start: today.to_s, stop: (today + 3).to_s).should be_value
    end

    it 'validates via message and boolean instance method' do
      klass = Class.new(Lego::Model) do
        attribute :start, Date
        attribute :stop, Date
        attribute :enabled, Boolean, default: ->{ true }

        validate 'must start before end', :start_after_end?
        validate 'at least 3 days after', :start_much_later?
        validate 'not enabled', :enabled?

        def start_after_end?
          start < stop
        end

        def start_much_later?
          (start + 2) < stop
        end

        def enabled?
          !!enabled
        end
      end

      klass.parse(start: today, stop: today).should be_error('must start before end')
      klass.parse(start: today, stop: today + 2).should be_error('at least 3 days after')
      klass.parse(start: today, stop: today + 3, enabled: false).should be_error('not enabled')
      klass.parse(start: today, stop: today + 3).should be_value
    end

    it 'validates via proc' do
    end

  end

end
