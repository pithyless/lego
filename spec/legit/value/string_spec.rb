require 'spec_helper'

describe Legit::Value::String do

  describe '#parse' do
    subject { Legit::Value::String.new(opts) }

    let(:allow_blank) { true }
    let(:strip) { true }

    let(:opts) do
      {
        allow_blank: allow_blank,
        strip: strip
      }
    end

    context 'nil' do
      specify { subject.parse(nil).should be_nothing }
    end

    context 'not a string' do
      specify { subject.parse(Date.new(2012, 12, 26)).should be_error('Not a string: 2012-12-26') }
      specify { subject.parse(123).should be_error('Not a string: 123') }
    end

    context 'allow blank' do
      let(:allow_blank) { true }

      context 'strip' do
        let(:strip) { true }
        specify { subject.parse('').should be_just('') }
        specify { subject.parse('   ').should be_just('') }
        specify { subject.parse(' foo  ').should be_just('foo') }
      end

      context 'no strip' do
        let(:strip) { false }
        specify { subject.parse('').should be_just('') }
        specify { subject.parse('   ').should be_just('   ') }
      end
    end

    context 'disallow blank' do
      let(:allow_blank) { false }

      context 'strip' do
        let(:strip) { true }
        specify { subject.parse('').should be_nothing }
        specify { subject.parse('   ').should be_nothing }
      end

      context 'no strip' do
        let(:strip) { false }
        specify { subject.parse('').should be_nothing }
        specify { subject.parse('   ').should be_nothing }
      end
    end

    context 'defaults' do
      subject { Legit::Value::String.new }

      its(:allow_blank?){ should == false }
      its(:strip?){ should == true }
    end

  end
end
