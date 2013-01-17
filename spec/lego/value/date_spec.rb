require 'spec_helper'

describe Lego::Value::Date do

  describe '#parse' do
    subject { Lego::Value::Date.new }

    context 'nil' do
      specify { subject.parse(nil).should be_nothing }
      specify { subject.parse('').should be_nothing }
    end

    context 'invalid date' do
      specify { subject.parse(123).should be_error("invalid date: '123'") }
      specify { subject.parse('2012-02').should be_error("invalid date: '2012-02'") }
    end

    it 'parses date' do
      subject.parse(Date.new(2012, 02, 01)).should be_just(Date.new(2012, 02, 01))
    end

    it 'parses time' do
      subject.parse(Time.new(2012, 02, 01, 8, 30)).should be_just(Date.new(2012, 02, 01))
    end

    it 'parses string date' do
      subject.parse('2012-02-01').should be_just(Date.new(2012, 02, 01))
    end

    it 'parses string time' do
      subject.parse('2012-02-01T08:30:00Z').should be_just(Date.new(2012, 02, 01))
    end
  end

  describe '#coerce' do
    context 'nothing' do
      context 'default' do
        it 'raises error' do
          expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
          expect{ subject.coerce('') }.to raise_error(Lego::CoerceError, 'missing value')
        end
      end

      context 'with :default handler' do
        subject { Lego::Value::String.new(default: handler) }

        context 'nil handler' do
          let(:handler) { ->{ nil } }
          specify { subject.coerce(nil).should be_nil }
        end

        context 'lambda handler' do
          let(:handler) { proc{ Date.new(2000, 1, 1) } }
          specify { subject.coerce('').should == Date.new(2000, 1, 1) }
        end
      end
    end

    context 'failure' do
      it 'raises error' do
        expect{ subject.coerce(123) }.to raise_error(Lego::CoerceError, "invalid date: '123'")
      end
    end

    context 'success' do
      it 'returns date' do
        subject.coerce(Date.new(2012, 02, 01)).should == Date.new(2012, 02, 01)
      end
    end
  end
end
