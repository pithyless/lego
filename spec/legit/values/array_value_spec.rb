require 'spec_helper'

describe Legit::Values::ArrayValue do

  context 'Array of Integers' do

    subject do
      Legit::Values::ArrayValue.new(split: ',',
          element: Legit::Values::IntegerValue.new(min: 0, max: 10))
    end

    it 'parses fixnums' do
      subject.user_value = [1,2,3]
      subject.parse_and_validate.should be_success_just([1,2,3])
    end

    it 'parses array of string' do
      subject.user_value = ['1', '2', '3']
      subject.parse_and_validate.should be_success_just([1,2,3])
    end

    it 'parses comma-delimited string' do
      subject.user_value = '  1,   2,   3    '
      subject.parse_and_validate.should be_success_just([1,2,3])
    end

    it 'is required by default' do
      subject.user_value = '  '
      subject.parse_and_validate.should be_failure('is required')
    end

    context 'required => true' do

      it 'nil is missing' do
        subject.user_value = nil
        subject.parse_and_validate.should be_failure('is required')
      end

      it 'empty array is missing' do
        subject.user_value = []
        subject.parse_and_validate.should be_failure('is required')
      end

      it 'empty string is missing' do
        subject.user_value = ''
        subject.parse_and_validate.should be_failure('is required')
      end

      it 'blank string is missing' do
        subject.user_value = '  '
        subject.parse_and_validate.should be_failure('is required')
      end

    end

    context 'required => false' do

      subject do
        Legit::Values::ArrayValue.new(required: false, split: ',',
            element: Legit::Values::IntegerValue.new(min: 0, max: 10))
      end

      it 'accepts nil' do
        subject.user_value = nil
        subject.parse_and_validate.should be_success_nothing
      end

      it 'accepts empty array' do
        subject.user_value = []
        subject.parse_and_validate.should be_success_nothing
      end

      it 'accepts empty string' do
        subject.user_value = ''
        subject.parse_and_validate.should be_success_nothing
      end

      it 'accepts blank string' do
        subject.user_value = '  '
        subject.parse_and_validate.should be_success_nothing
      end

    end

    context 'element failures' do

      it 'fails if any elements fail' do
        subject.user_value = [1, 20, 3]
        subject.parse_and_validate.should be_failure(["20: must be at most 10"])
      end

      it 'concats all failures' do
        subject.user_value = '1, 20, bob, , 3'
        subject.parse_and_validate.should be_failure(
          [" 20: must be at most 10", " bob: not an integer", " : is required"]
        )
      end

      it 'does not allow empty elements' do
        s = Legit::Values::ArrayValue.new(required: false, split: ',',
              element: Legit::Values::IntegerValue.new(required: false))
        s.user_value = '1, 2, , 4'
        s.parse_and_validate.should be_failure(["Empty value in array:  "])
      end

    end

  end

  context 'Array of Strings' do

    subject do
      Legit::Values::ArrayValue.new(split: ',',
          element: Legit::Values::StringValue.new(strip: true, downcase: true))
    end

    it 'parses and downcases strings' do
      subject.user_value = '  foo, bAR,    BAZ, qUx,    wh4cky$   '
      subject.parse_and_validate.should be_success_just(["foo", "bar", "baz", "qux", "wh4cky$"])
    end

  end

end
