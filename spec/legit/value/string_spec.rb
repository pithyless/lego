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
      specify { subject.parse(Date.new(2012, 12, 26)).should be_error("invalid string: '2012-12-26'") }
      specify { subject.parse(123).should be_error("invalid string: '123'") }
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


  describe '#coerce' do
    context 'nothing' do
      context 'default' do
        it 'raises error' do
          expect{ subject.coerce(nil) }.to raise_error(Legit::CoerceError, 'missing value')
          expect{ subject.coerce('') }.to raise_error(Legit::CoerceError, 'missing value')
          expect{ subject.coerce('  ') }.to raise_error(Legit::CoerceError, 'missing value')
        end
      end

      context 'with :default handler' do
        subject { Legit::Value::String.new(default: handler) }

        context 'nil handler' do
          let(:handler) { ->{ nil } }
          specify { subject.coerce(nil).should be_nil }
        end

        context 'lambda handler' do
          let(:handler) { ->{ 'missing' } }
          specify { subject.coerce('  ').should == 'missing' }
        end
      end
    end

    context 'failure' do
      it 'raises error' do
        expect{ subject.coerce(123) }.to raise_error(Legit::CoerceError, "invalid string: '123'")
      end
    end

    context 'success' do
      it 'returns string' do
        subject.coerce('foo bar').should == 'foo bar'
      end
    end
  end
end
