require 'spec_helper'

describe 'Integration' do

end

module Lego

  describe StringParser do
    it 'succeeds for string value' do
      subject.call('foo').value.should == 'foo'
    end

    it 'fails for integer' do
      subject.call(123).error.should == CoerceError.new(:string, 123)
    end

    it 'fails for blank' do
      subject.call('  ').error.should == BlankError.new('  ')
    end
  end

  class PersonParser < Lego::Model
    attr :name, StringParser.new
  end

  describe PersonParser do
    it 'returns hash' do
      subject.call({'name' => 'foo'}).value.should == { name: 'foo' }
    end

    it 'fails for integer' do
      subject.call({'name' => 123}).error.should == Lego::ModelError.new({name: Lego::CoerceError.new(:string, 123)})
    end
  end

  class GroupParser < Lego::Model
    attr :person, PersonParser.new
  end

  describe PersonParser do
    it 'returns hash' do
      subject.call({ 'person' => {'name' => 'foo'}}).value.should == { person: { name: 'foo' } }
    end

    it 'fails for integer' do
      subject.call({ 'person' => {'name' => 123}}).error.should == Lego::ModelError.new(
        person: Lego::ModelError.new(name: Lego::CoerceError.new(:string, 123))
      )
    end
  end


end
