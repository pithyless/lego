require 'spec_helper'

module Lego

  describe Parse::String do
    it 'succeeds for string value' do
      subject.call('foo').value.should == 'foo'
    end

    it 'fails for integer' do
      subject.call(123).error.should == Violation::Coercion.new(:string, 123)
    end

    it 'fails for blank' do
      subject.call('  ').error.should == Violation::Blank.new('  ')
    end
  end

  describe Parse::Schema do
    let(:schema) do
      {
        name: Parse::String.new,
        age:  Parse::Integer.new
      }
    end

    subject do
      described_class.new(schema)
    end

    it 'succeeds for valid schema' do
      subject.call(name: 'Bob', age: '10').value.should == { name: 'Bob', age: 10 }
    end

    it 'fails for non-hash' do
      subject.call('a string').error.should == Violation::Coercion.new(:hash, 'a string')
    end

    it 'fails for nil (empty hash)' do
      subject.call(nil).error.should == Violation::KeyCollection.new({
        name: Lego::Failure.new(Violation::Coercion.new(:string, nil)),
        age: Lego::Failure.new(Violation::Coercion.new(:integer, nil))
      })
    end
  end

  module TestModels
    class Person < Lego::Model
      key :name, Lego::Parse::String
      key :age,  Lego::Parse::Integer
    end

    class Team < Lego::Model
      key :members, Lego::Parse::Array.new(Person.parser, min: 1)
    end

    describe 'Person' do
      it 'succeeds for valid schema' do
        Person.parser.call({ name: 'Bob', age: '10' }).value.should == { name: 'Bob', age: 10 }
      end

      it 'fails for invalid item' do
        Person.parser.call({ name: 'Bob', age: 'invalid' }).error.should == Violation::KeyCollection.new(
          name: Lego::Success.new('Bob'),
          age: Lego::Failure.new(Violation::Coercion.new(:integer, 'invalid'))
        )
      end
    end

    describe 'Team' do
      it 'succeeds for valid schema' do
        Team.parser.call(members: [{ name: 'Bob', age: '10' }]).value.should == { members: [{ name: 'Bob', age: 10 }] }
      end

      it 'fails for invalid item' do
        Team.parser.call(members: [{ name: 'Bob', age: 'invalid' }]).error.should == Violation::KeyCollection.new(
          members: Lego::Failure.new(Violation::Collection.new([
            Lego::Failure.new(Violation::KeyCollection.new(
              name: Lego::Success.new('Bob'),
              age: Lego::Failure.new(Violation::Coercion.new(:integer, 'invalid'))
            ))
          ]))
        )
      end
    end
  end

end

#  class PersonParser < Lego::Model
#    attr :name, StringParser.new
#  end
#
#  describe PersonParser do
#    it 'returns hash' do
#      subject.call({'name' => 'foo'}).value.should == { name: 'foo' }
#    end
#
#    it 'fails for integer' do
#      subject.call({'name' => 123}).error.should == Lego::ModelError.new({name: Lego::CoerceError.new(:string, 123)})
#    end
#  end
#
#  class GroupParser < Lego::Model
#    attr :person, PersonParser.new
#  end
#
#  describe PersonParser do
#    it 'returns hash' do
#      subject.call({ 'person' => {'name' => 'foo'}}).value.should == { person: { name: 'foo' } }
#    end
#
#    it 'fails for integer' do
#      subject.call({ 'person' => {'name' => 123}}).error.should == Lego::ModelError.new(
#        person: Lego::ModelError.new(name: Lego::CoerceError.new(:string, 123))
#      )
#    end
#  end
