require 'spec_helper'

describe Legit::Values::IntegerValue do

  it 'parses string' do
    subject.user_value = '123'
    subject.parse_and_validate.should be_success_just(123)
  end

  it 'parses string with spaces' do
    subject.user_value = '   123   '
    subject.parse_and_validate.should be_success_just(123)
  end

  it 'parses Fixnum' do
    subject.user_value = 123
    subject.parse_and_validate.should be_success_just(123)
  end

  it 'is required by default' do
    subject.user_value = '  '
    subject.parse_and_validate.should be_failure('is required')
  end

  context 'required => true' do
    subject do
      Legit::Values::IntegerValue.new({required: true})
    end

    it 'blank is missing' do
      subject.user_value = '  '
      subject.parse_and_validate.should be_failure('is required')
    end

    it 'nil is missing' do
      subject.user_value = nil
      subject.parse_and_validate.should be_failure('is required')
    end

    it 'empty is missing' do
      subject.user_value = ''
      subject.parse_and_validate.should be_failure('is required')
    end
  end

  context 'required => false' do
    subject do
      Legit::Values::IntegerValue.new({required: false})
    end

    it 'accepts blank strings' do
      subject.user_value = '  '
      subject.parse_and_validate.should be_success_nothing
    end

    it 'accepts nil' do
      subject.user_value = nil
      subject.parse_and_validate.should be_success_nothing
    end

    it 'accepts empty strings' do
      subject.user_value = ''
      subject.parse_and_validate.should be_success_nothing
    end
  end

  context 'minimum' do
    subject do
      Legit::Values::IntegerValue.new({min: 10, required: false})
    end

    it 'within limit' do
      subject.user_value = '5'
      subject.parse_and_validate.should be_failure('must be at least 10')
    end

    it 'outside limit' do
      subject.user_value = 20
      subject.parse_and_validate.should be_success_just(20)
    end

    it 'missing is OK' do
      subject.user_value = ''
      subject.parse_and_validate.should be_success_nothing
    end
  end

  context 'minimum' do
    subject do
      Legit::Values::IntegerValue.new({max: 50, required: false})
    end

    it 'within limit' do
      subject.user_value = 55
      subject.parse_and_validate.should be_failure('must be at most 50')
    end

    it 'outside limit' do
      subject.user_value = 50
      subject.parse_and_validate.should be_success_just(50)
    end

    it 'missing is OK' do
      subject.user_value = ''
      subject.parse_and_validate.should be_success_nothing
    end
  end

end
