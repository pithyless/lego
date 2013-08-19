require 'spec_helper'

describe Lego::Value::String do

  describe '#parse' do
    subject { Lego::Value::String.new(opts) }

    let(:allow_blank) { true }
    let(:strip) { true }

    let(:opts) do
      {
        allow_blank: allow_blank,
        strip: strip,
        default: ->{ 'DEFAULT' }
      }
    end

    context 'nil' do
      specify { subject.parse(nil).should be_just('DEFAULT') }
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
        specify { subject.parse('').should be_just('DEFAULT') }
        specify { subject.parse('   ').should be_just('DEFAULT') }
      end

      context 'no strip' do
        let(:strip) { false }
        specify { subject.parse('').should be_just('DEFAULT') }
        specify { subject.parse('   ').should be_just('DEFAULT') }
      end
    end

    context 'matches' do
      subject { Lego::Value::String.new(opts.merge(matches: /^[A-Z]{3}$/)) }

      specify { subject.parse(nil).should be_just('DEFAULT') }
      specify { subject.parse(123).should be_error("invalid string: '123'") }

      specify { subject.parse('abc').should be_error("does not match (/^[A-Z]{3}$/): 'abc'") }
      specify { subject.parse('TLC').should be_just('TLC') }
    end

    context 'defaults' do
      subject { Lego::Value::String.new }

      its(:allow_blank?){ should == false }
      its(:strip?){ should == true }
    end

    context 'allow' do
      subject { Lego::Value::String.new(allow: %w{mon tue wed thu fri sat sun}) }

      specify { subject.parse('mon').should be_just('mon') }
      specify { subject.parse('sat').should be_just('sat') }

      specify { subject.parse('Mon').should be_error("not allowed: 'Mon'") }
      specify { subject.parse('foo').should be_error("not allowed: 'foo'") }
    end

  end


  describe '#coerce' do
    context 'nothing' do
      context 'default' do
        it 'raises error' do
          expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
          expect{ subject.coerce('') }.to raise_error(Lego::CoerceError, 'missing value')
          expect{ subject.coerce('  ') }.to raise_error(Lego::CoerceError, 'missing value')
        end
      end

      context 'with :default handler' do
        subject { Lego::Value::String.new(default: handler) }

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
        expect{ subject.coerce(123) }.to raise_error(Lego::CoerceError, "invalid string: '123'")
      end
    end

    context 'success' do
      it 'returns string' do
        subject.coerce('foo bar').should == 'foo bar'
      end
    end
  end
end
