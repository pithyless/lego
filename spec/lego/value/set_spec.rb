require 'spec_helper'

describe Lego::Value::Set do

  def set(elem)
    Array(elem).to_set
  end

  subject { Lego::Value::Set.new(String, default: ->{ 'DEFAULT' } ) }

  describe '#parse' do
    context 'nil' do
      specify { subject.parse(nil).should be_just('DEFAULT') }
    end

    context 'invalid set or item' do
      specify { subject.parse('').should be_error("invalid set: ''") }
      specify { subject.parse('2012-02').should be_error("invalid set: '2012-02'") }
      specify { subject.parse(['one', 123, 'two']).should be_error([nil, "invalid string: '123'", nil]) }
    end

    it 'parses array' do
      subject.parse(['one']).should be_just(set('one'))
    end

    it 'parses set' do
      subject.parse(set('one')).should be_just(set('one'))
    end

    context 'allow empty' do
      subject { Lego::Value::Set.new(String, allow_empty: true) }
      specify { subject.parse([]).should be_just(set([])) }
    end

    context 'disallow empty' do
      subject { Lego::Value::Set.new(String, allow_empty: false, default: ->{ 'DEFAULT' }) }
      specify { subject.parse([]).should be_just('DEFAULT') }
    end
  end

  describe '#coerce' do
    subject { Lego::Value::Set.new(String) }

    context 'missing' do
      it 'raises error' do
        expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
        expect{ subject.coerce([]) }.to raise_error(Lego::CoerceError, 'missing value')
        expect{ subject.coerce([].to_set) }.to raise_error(Lego::CoerceError, 'missing value')
      end

      context 'with :default handler' do
        subject { Lego::Value::Set.new(String, default: handler) }

        context 'nil handler' do
          let(:handler) { ->{ nil } }
          specify { subject.coerce(nil).should be_nil }
        end

        context 'lambda handler' do
          let(:handler) { proc{ Set.new } }
          specify { subject.coerce(nil).should == [].to_set }
        end
      end
    end

    context 'failure' do
      it 'raises error' do
        expect{ subject.coerce([123]) }.to raise_error(Lego::CoerceError, ["invalid string: '123'"].inspect)
      end
    end

    context 'success' do
      it 'returns set' do
        subject.coerce(['foo']).should == set('foo')
      end
    end
  end

end
