require 'spec_helper'

module Lego
  shared_examples_for 'a Success' do
    it '#value' do
      subject.must_be :value?
    end

    it '#error' do
      subject.wont_be :error?
    end

    it '#value' do
      subject.value.must_be_same_as value
    end

    it '#error' do
      ->{ subject.error }.must_raise NoMethodError
    end

    it '#fetch' do
      subject.fetch.must_be_same_as value
    end
  end

  shared_examples_for 'a Failure' do
    it '#value' do
      subject.wont_be :value?
    end

    it '#error' do
      subject.must_be :error?
    end

    it '#value' do
      ->{ subject.value }.must_raise NoMethodError
    end

    it '#error' do
      subject.error.must_be_same_as error
    end

    it '#fetch' do
      ->{ subject.fetch }.must_raise RuntimeError
    end
  end

  describe 'ValueSuccess' do
    let(:value) { Object.new }
    subject { ValueSuccess.new(value) }

    it_behaves_like 'a Success'

    describe '#bind' do
      it 'calls block with value' do
        subject.bind{ |v| Lego::ValueSuccess.new(v.object_id) }.must_equal_value_success value.object_id
      end

      it 'calls callable with value' do
        callable = ->(v){ Lego::ValueSuccess.new(v.object_id) }
        subject.bind(callable).must_equal_value_success value.object_id
      end

      it 'fails if return is not a Success or Failure' do
        callable = ->(v){ 'unwrapped_value' }
        ->{ subject.bind(callable) }.must_raise TypeError
      end
    end
  end

  describe 'ValueFailure' do
    let(:error) { Object.new }
    subject { ValueFailure.new(error) }

    it_behaves_like 'a Failure'

    describe '#bind' do
      it 'does not call block with value' do
        subject.bind{ |v| fail 'Oh No!' } # No error
      end

      it 'does not call callable with value' do
        callable = ->(v){ fail 'Oh No!' }
        subject.bind(callable)            # No error
      end

      it 'returns self' do
        subject.bind{ |v| v }.must_be_same_as subject
      end

      it 'returns failure' do
        subject.bind{ |v| v }.must_equal_value_failure error
      end
    end
  end

  describe 'SchemaSuccess' do
    let(:one) { Object.new }
    let(:two) { Object.new }
    let(:schema) { { one: one, two: two } }
    subject { SchemaSuccess.new(schema) }

    # TODO: it_behaves_like 'a Success'

    describe '#bind' do
      it 'calls block with schema' do
        subject.bind{ |v| Lego::SchemaSuccess.new(v.object_id) }.must_equal_schema_success schema.map(&:object_id)
      end

      #it 'calls callable with schema' do
      #  callable = ->(v){ Lego::SchemaSuccess.new(v.object_id) }
      #  subject.bind(callable).must_equal_schema_success schema.object_id
      #end

      #it 'fails if return is not a Success or Failure' do
      #  callable = ->(v){ 'unwrapped_schema' }
      #  ->{ subject.bind(callable) }.must_raise TypeError
      #end
    end
  end

end
