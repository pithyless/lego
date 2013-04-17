require 'spec_helper'

module Lego
  shared_examples_for 'a Success' do
    it '#value' do
      subject.must_be :value?
    end

    it '#error' do
      subject.wont_be :error?
    end

    it '#fetch' do
      subject.fetch.must_equal value
    end

    it '#value' do
      subject.value.must_equal value
    end

    it '#error' do
      ->{ subject.error }.must_raise NoMethodError
    end
  end

  shared_examples_for 'a Failure' do
    it '#value' do
      subject.wont_be :value?
    end

    it '#error' do
      subject.must_be :error?
    end

    it '#fetch' do
      ->{ subject.fetch }.must_raise RuntimeError
    end

    it '#value' do
      ->{ subject.value }.must_raise NoMethodError
    end

    it '#error' do
      subject.error.must_equal error
    end
  end


  describe 'ValueSuccess' do
    let(:value) { Object.new }
    subject { ValueSuccess.new(value) }

    it_behaves_like 'a Success'
  end

  describe 'ValueFailure' do
    let(:error) { Object.new }
    subject { ValueFailure.new(error) }

    it_behaves_like 'a Failure'
  end
end
