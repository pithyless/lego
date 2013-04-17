require 'spec_helper'

module Lego
  describe ValueSuccess do
    let(:value) { Object.new }

    subject { ValueSuccess.new(value) }

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
end
