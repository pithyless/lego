require 'spec_helper'

describe Legit::Value::String do

  describe '#parse' do
    it 'nil is None' do
      subject.parse(nil).should be_nothing
    end

    it 'returns Fail if not a string' do
      subject.parse(Date.new(2012, 12, 26)).should be_error('Not a string: 2012-12-26')
      subject.parse(123).should be_error('Not a string: 123')
    end

    context 'allow blank' do
      subject { Legit::Value::String.new(allow_blank: true, strip: false) }

      it 'blank string is Just' do
        subject.parse('').should be_just('')
      end

      it 'empty string is Just' do
        subject.parse('  ').should be_just('  ')
      end
    end

    context 'disallow blank' do
      subject { Legit::Value::String.new(allow_blank: false, strip: false) }

      it 'blank string is None' do
        subject.parse('').should be_nothing
      end

      it 'empty string is None' do
        subject.parse('  ').should be_nothing
      end
    end

    context 'strip' do
      subject { Legit::Value::String.new(allow_blank: true, strip: true) }

      it 'empty string is Just' do
        subject.parse('   ').should be_just('')
      end

      it 'string is stripped' do
        subject.parse('  foo  ').should be_just('foo')
      end
    end

    it 'defaults' do
      subject.allow_blank?.should == true
      subject.strip?.should == true
    end

  end
end
