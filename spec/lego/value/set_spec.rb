require 'spec_helper'

describe Lego::Value::Set do

  def set(elem)
    Array(elem).to_set
  end

  subject { Lego::Value::Set.new(:string) }

  describe '#parse' do
    context 'nil' do
      specify { subject.parse(nil).should be_nothing }
    end

    context 'invalid set or item' do
      specify { subject.parse('').should be_error("invalid set: ''") }
      specify { subject.parse('2012-02').should be_error("invalid set: '2012-02'") }
      specify { subject.parse(['one', 123, 'two']).should be_error("invalid string: '123'") }
    end

    it 'parses array' do
      subject.parse(['one']).should be_just(set('one'))
    end

    it 'parses set' do
      subject.parse(set('one')).should be_just(set('one'))
    end

    context 'allow empty' do
      subject { Lego::Value::Set.new(:string, allow_empty: true) }
      specify { subject.parse([]).should be_just(set([])) }
    end

    context 'disallow empty' do
      subject { Lego::Value::Set.new(:string, allow_empty: false) }
      specify { subject.parse([]).should be_nothing }
    end
  end

  describe '#coerce' do
    context 'missing' do
      it 'raises error' do
        expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
        expect{ subject.coerce([]) }.to raise_error(Lego::CoerceError, 'missing value')
        expect{ subject.coerce([].to_set) }.to raise_error(Lego::CoerceError, 'missing value')
      end

      context 'with :default handler' do
        subject { Lego::Value::String.new(default: handler) }

        context 'nil handler' do
          let(:handler) { ->{ nil } }
          specify { subject.coerce(nil).should be_nil }
        end

        context 'lambda handler' do
          let(:handler) { proc{ Set.new } }
          specify { subject.coerce('').should == [].to_set }
        end
      end
    end

    context 'failure' do
      it 'raises error' do
        expect{ subject.coerce([123]) }.to raise_error(Lego::CoerceError, "invalid string: '123'")
      end
    end

    context 'success' do
      it 'returns set' do
        subject.coerce(['foo']).should == set('foo')
      end
    end
  end

end
