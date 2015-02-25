require 'spec_helper'

describe Lego::Value::Hash do
  describe '#parse' do
    context 'parses nil' do
      subject { Lego::Value::Hash.new(allow_empty:false, default: -> { {key: 'value' } }) }
      specify { subject.parse(nil).should be_just({ key: 'value' }) }
    end

    context 'allow empty' do
      subject { Lego::Value::Hash.new(allow_empty: true) }

      it 'parses empty hash' do
        subject.parse({}).should be_just({}) 
      end
    end

    context 'disallow empty' do
      subject { Lego::Value::Hash.new(allow_empty:false, default: -> { {key: 'value' } }) }
      specify { subject.parse({}).should be_just({key: 'value' }) }
    end

    let(:hash) {{
      key: 'value',
      key2: 3,
      key3: {
        nested_key: Object.new,
        nested_key2: 'nested value'
      }
    }}

    it 'parses non-empty hash' do
      result = subject.parse(hash)
      result.should be_just(hash)
      result.value.should be_frozen
    end

    context 'returns error when invalid hash' do
      specify { subject.parse('').should be_error('invalid hash: ""') }
      specify { subject.parse([]).should be_error('invalid hash: []') }
      specify { subject.parse(6).should be_error('invalid hash: 6') }
    end 
  end

  describe '#coerce' do
    context 'missing' do
      it 'raises error' do
        expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
        expect{ subject.coerce({}) }.to raise_error(Lego::CoerceError, 'missing value')
      end
    end

    context 'with :default handler' do
      subject { Lego::Value::Hash.new(default: handler) }

      context 'nil handler' do
        let(:handler) { -> { nil } }
        specify { subject.coerce(nil).should be_nil }
      end

      context 'lambda handler' do
        let(:default_hash) { { key: 'value'} }
        let(:handler) { -> { default_hash } }
        specify { subject.coerce(nil).should == default_hash }
      end
    end

    context 'failure' do
      it 'raises error' do
        expect { subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
      end
    end

    context 'success' do
      it 'returns hash' do
        subject.coerce({key: 'value' }).should == { key: 'value' }
      end
    end
  end
end
