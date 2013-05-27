#require 'spec_helper'
#
#describe Lego::Value::Boolean do
#
#  describe '#parse' do
#    context 'nil' do
#      subject { Lego::Value::Boolean.new(default: ->{ 'DEFAULT' }) }
#
#      specify { subject.parse(nil).should be_just('DEFAULT') }
#      specify { subject.parse('').should be_just('DEFAULT') }
#    end
#
#    context 'boolean string' do
#      specify { subject.parse('true').should be_just(true) }
#      specify { subject.parse('false').should be_just(false) }
#    end
#
#    context 'boolean value' do
#      specify { subject.parse(true).should be_just(true) }
#      specify { subject.parse(false).should be_just(false) }
#    end
#
#    context 'invalid value' do
#      specify { subject.parse('wtf').should be_error("invalid boolean: 'wtf'") }
#      specify { subject.parse('   ').should be_error("invalid boolean: '   '") }
#      specify { subject.parse(0).should be_error("invalid boolean: '0'") }
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
#      context 'default handler -> false' do
#        subject { Lego::Value::Boolean.new(default: ->{ false }) }
#        specify { subject.coerce(nil).should == false }
#        specify { subject.coerce('').should == false }
#        specify { subject.coerce(true).should == true }
#      end
#
#      context 'default handler -> true' do
#        subject { Lego::Value::Boolean.new(default: ->{ true }) }
#        specify { subject.coerce(nil).should == true }
#        specify { subject.coerce('').should == true }
#        specify { subject.coerce(false).should == false }
#      end
#    end
#
#    context 'failure' do
#      it 'raises error' do
#        expect{ subject.coerce(123) }.to raise_error(Lego::CoerceError, "invalid boolean: '123'")
#      end
#    end
#
#    context 'success' do
#      specify { subject.coerce(true).should == true }
#    end
#  end
#end
