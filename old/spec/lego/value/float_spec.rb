#require 'spec_helper'
#
#describe Lego::Value::Float do
#
#  describe '#parse' do
#    subject { Lego::Value::Float.new(opts) }
#
#    let(:opts){ {} }
#
#    context 'nil' do
#      let(:opts){ {default: ->{ 42.0 } } }
#
#      specify { subject.parse(nil).should be_just(42.0) }
#      specify { subject.parse('').should be_just(42.0) }
#    end
#
#    context 'invalid float' do
#      specify { subject.parse('  ').should be_error("invalid float: '  '") }
#      specify { subject.parse('2012-02').should be_error("invalid float: '2012-02'") }
#      specify { subject.parse('invalid').should be_error("invalid float: 'invalid'") }
#    end
#
#    it 'parses integer as float' do
#      subject.parse(123).should be_just(123.0)
#    end
#
#    it 'parses float' do
#      subject.parse(123.12).should be_just(123.12)
#    end
#
#    it 'parses string integer as float' do
#      subject.parse('-134').should be_just(-134.0)
#    end
#
#    it 'parses string float' do
#      subject.parse('-134.11').should be_just(-134.11)
#    end
#
#    context 'minimum' do
#      let(:opts){ { min: 4 } }
#      specify { subject.parse(4).should be_just(4) }
#      specify { subject.parse(3.99999).should be_error("less than minimum of 4: '3.99999'") }
#    end
#
#    context 'maximum' do
#      let(:opts){ { max: 4 } }
#      specify { subject.parse(4).should be_just(4) }
#      specify { subject.parse(4.01).should be_error("more than maximum of 4: '4.01'") }
#    end
#
#    context 'minimium and maximum' do
#      let(:opts){ { min: 0, max: 4 } }
#      specify { subject.parse(1.1).should be_just(1.1) }
#      specify { subject.parse(-0.1).should be_error("less than minimum of 0: '-0.1'") }
#      specify { subject.parse(4.1).should be_error("more than maximum of 4: '4.1'") }
#    end
#  end
#
#  describe '#coerce' do
#    context 'nothing' do
#      context 'default' do
#        it 'raises error' do
#          expect{ subject.coerce(nil) }.to raise_error(Lego::CoerceError, 'missing value')
#          expect{ subject.coerce('') }.to raise_error(Lego::CoerceError, 'missing value')
#        end
#      end
#
#      context 'with :default handler' do
#        subject { Lego::Value::Float.new(default: handler) }
#
#        context 'nil handler' do
#          let(:handler) { ->{ nil } }
#          specify { subject.coerce(nil).should be_nil }
#        end
#
#        context 'lambda handler' do
#          let(:handler) { ->{ 42.0 } }
#          specify { subject.coerce('').should == 42.0 }
#        end
#      end
#    end
#
#    context 'failure' do
#      it 'raises error' do
#        expect{ subject.coerce('foo') }.to raise_error(Lego::CoerceError, "invalid float: 'foo'")
#      end
#    end
#
#    context 'success' do
#      it 'returns float' do
#        subject.coerce('42').should == 42.0
#      end
#    end
#  end
#end
