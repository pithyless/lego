require 'spec_helper'

describe Legit::Values::BooleanValue do

  context 'true values' do
    it '"true"' do
      subject.user_value = 'true'
      subject.parse_and_validate.should be_success_just(true)
    end

    it '"1"' do
      subject.user_value = '1'
      subject.parse_and_validate.should be_success_just(true)
    end

    it 'true' do
      subject.user_value = true
      subject.parse_and_validate.should be_success_just(true)
    end
  end

  context 'false values' do
    it '"false"' do
      subject.user_value = 'false'
      subject.parse_and_validate.should be_success_just(false)
    end

    it '"0"' do
      subject.user_value = '0'
      subject.parse_and_validate.should be_success_just(false)
    end

    it 'false' do
      subject.user_value = false
      subject.parse_and_validate.should be_success_just(false)
    end
  end

  it 'fails on other string values' do
    subject.user_value = '   true   '
    subject.parse_and_validate.should be_failure('unrecognized boolean value: "   true   "')
  end

  it 'is required by default' do
    subject.user_value = nil
    subject.parse_and_validate.should be_failure('is required')
  end

  context 'required => false' do
    subject do
      Legit::Values::BooleanValue.new({required: false})
    end

    it 'accepts nil' do
      subject.user_value = nil
      subject.parse_and_validate.should be_success_nothing
    end
  end

end
