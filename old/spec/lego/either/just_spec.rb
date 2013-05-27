#require 'spec_helper'
#
#describe Lego::Either::Just do
#
#  subject { Lego::Either::Just.new(2) }
#
#  describe '#initialize' do
#    its(:value?) { should == true }
#    its(:none?)  { should == false }
#    its(:error?) { should == false }
#
#    its(:value) { should == 2 }
#
#    it 'fails for :error' do
#      ->{ subject.error }.should raise_error(NoMethodError)
#    end
#
#    it 'defines shortcut' do
#      Lego.just(1).should be_value
#    end
#  end
#
#  describe '#next' do
#    it 'binds and calls callable' do
#      callable = ->(val) { fail "Call me - #{val}" }
#      ->{ subject.next(callable) }.should raise_error('Call me - 2')
#    end
#
#    it 'returns new Just' do
#      callable = ->(num) { Lego.just(num * 20) }
#      subject.next(callable).should be_just(40)
#    end
#
#    it 'returns None' do
#      callable = ->(num) { Lego.none }
#      subject.next(callable).should be_nothing
#    end
#
#    it 'returns Fail' do
#      callable = ->(num) { Lego.fail('oops') }
#      subject.next(callable).should be_error('oops')
#    end
#
#    it 'fails on not Eitherish return value' do
#      callable = ->(num) { 'a string' }
#      ->{ subject.next(callable) }.should raise_error(TypeError, /Not Lego::Either/)
#    end
#  end
#
#end
