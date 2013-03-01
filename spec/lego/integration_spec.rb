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

    #it 'fails for integer' do
    #  subject.call(123).error.should == Lego::Violation::Coercion.new(:string, 123)
    #end

    #it 'fails for blank' do
    #  subject.call('  ').error.should == Lego::Violation::Blank.new('  ')
    #end
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


end
