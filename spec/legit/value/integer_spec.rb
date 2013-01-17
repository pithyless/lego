require 'spec_helper'

describe Legit::Value::Integer do

  describe '#parse' do
    subject { Legit::Value::Integer.new(opts) }

    let(:opts){ {} }

    context 'nil' do
      specify { subject.parse(nil).should be_nothing }
      specify { subject.parse('').should be_nothing }
    end

    context 'invalid integer' do
      specify { subject.parse('  ').should be_error("invalid integer: '  '") }
      specify { subject.parse(123.456).should be_error("invalid integer: '123.456'") }
      specify { subject.parse('2012-02').should be_error("invalid integer: '2012-02'") }
      specify { subject.parse('invalid').should be_error("invalid integer: 'invalid'") }
    end

    it 'parses integer' do
      subject.parse(123).should be_just(123)
    end

    it 'parses string integer' do
      subject.parse('-134').should be_just(-134)
    end

    context 'minimum' do
      let(:opts){ { min: 4 } }
      specify { subject.parse(4).should be_just(4) }
      specify { subject.parse(3).should be_error("less than minimum of 4: '3'") }
    end

    context 'maximum' do
      let(:opts){ { max: 4 } }
      specify { subject.parse(4).should be_just(4) }
      specify { subject.parse(5).should be_error("more than maximum of 4: '5'") }
    end

    context 'minimium and maximum' do
      let(:opts){ { min: 0, max: 4 } }
      specify { subject.parse(1).should be_just(1) }
      specify { subject.parse(-1).should be_error("less than minimum of 0: '-1'") }
      specify { subject.parse(5).should be_error("more than maximum of 4: '5'") }
    end
  end

  describe '#coerce' do
    context 'nothing' do
      context 'default' do
        it 'raises error' do
          expect{ subject.coerce(nil) }.to raise_error(Legit::CoerceError, 'missing value')
          expect{ subject.coerce('') }.to raise_error(Legit::CoerceError, 'missing value')
        end
      end

      context 'with :default handler' do
        subject { Legit::Value::Integer.new(default: handler) }

        context 'nil handler' do
          let(:handler) { ->{ nil } }
          specify { subject.coerce(nil).should be_nil }
        end

        context 'lambda handler' do
          let(:handler) { ->{ 42 } }
          specify { subject.coerce('').should == 42 }
        end
      end
    end

    context 'failure' do
      it 'raises error' do
        expect{ subject.coerce('foo') }.to raise_error(Legit::CoerceError, "invalid integer: 'foo'")
      end
    end

    context 'success' do
      it 'returns integer' do
        subject.coerce('42').should == 42
      end
    end
  end
end
