require 'spec_helper'

module Lego

  describe 'Model validation', :focus do

    class TestPerson < Lego::Model
      attribute :name, String
      attribute :age,  Integer
    end

    class TestGroup < Lego::Model
      attribute :people, Array, TestPerson
    end


    context 'invalid params' do
      subject do
        TestPerson.parse(name: name, age: age)
      end

      let(:name){ '' }
      let(:age){ 'invalid' }

      it 'returns all errors' do
        subject.error.errors[:name].message.should == :blank
        subject.error.errors[:age].message.should == :not_an_integer
      end
    end

    context 'invalid nested params' do
      subject do
        TestGroup.parse(people: [{name: 'Bob', age: 10}, {name: name, age: age}])
      end

      let(:name){ '' }
      let(:age){ 'invalid' }

      it 'returns all errors' do
        p subject.error
        subject.error.errors[:name].message.should == :blank
        subject.error.errors[:age].message.should == :not_an_integer
      end
    end

  end

end
