require 'spec_helper'

describe Lego::Value::Array do

  subject { Lego::Value::Array.new(String) }

  describe '#parse' do
    context 'nil' do
      subject { Lego::Value::Array.new(String, allow_empty: false, default: ->{ 'DEFAULT' }) }
      specify { subject.parse(nil).should be_just('DEFAULT') }
    end

    context 'invalid array or item' do
      specify { subject.parse('').should be_error("invalid array: ''") }
      specify { subject.parse('2012-02').should be_error("invalid array: '2012-02'") }
      specify { subject.parse(['one', 123, 'two']).should be_error([nil, "invalid string: '123'", nil]) }
    end

    it 'parses array' do
      subject.parse(['one']).should be_just(['one'])
    end

    context 'allow empty' do
      subject { Lego::Value::Array.new(String, allow_empty: true) }
      specify { subject.parse([]).should be_just([]) }
    end

    context 'disallow empty' do
      subject { Lego::Value::Array.new(String, allow_empty: false, default: ->{ 'DEFAULT' }) }
      specify { subject.parse([]).should be_just('DEFAULT') }
    end

    context 'check length' do
      subject { Lego::Value::Array.new(Integer, length: 2) }
      specify { subject.parse([]).should be_error("length not 2: '[]'") }
      specify { subject.parse([1]).should be_error("length not 2: '[1]'") }
      specify { subject.parse([1, 2, 3]).should be_error("length not 2: '[1, 2, 3]'") }
      specify { subject.parse([42, 24]).should be_just([42, 24]) }
    end

    context 'passess children_opts to children parser' do
      subject { Lego::Value::Array.new(String, children_opts: { allow_blank: true, default: -> { 'default' }} )}
      specify { subject.parse(["abc", "", nil]).should be_just(["abc", "", "default"])}
    end
  end

  describe '#coerce' do
    context 'missing' do
      it 'raises error' do
        expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
        expect{ subject.coerce([]) }.to raise_error(Lego::CoerceError, 'missing value')
      end

      context 'with :default handler' do
        subject { Lego::Value::Array.new(String, default: handler) }

        context 'nil handler' do
          let(:handler) { ->{ nil } }
          specify { subject.coerce(nil).should be_nil }
        end

        context 'lambda handler' do
          let(:handler) { proc{ ['default'] } }
          specify { subject.coerce(nil).should == ['default'] }
        end
      end
    end

    context 'failure' do
      it 'raises error' do
        expect{ subject.coerce([123]) }.to raise_error(Lego::CoerceError, ["invalid string: '123'"].inspect)
      end
    end

    context 'success' do
      it 'returns array' do
        subject.coerce(['foo']).should == ['foo']
      end
    end
  end

end
