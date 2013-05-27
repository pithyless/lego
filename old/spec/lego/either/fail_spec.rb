#require 'spec_helper'
#
#describe Lego::Either::Fail do
#
#  subject { Lego::Either::Fail.new(2) }
#
#  describe '#initialize' do
#
#    its(:error?) { should == true }
#    its(:none?)  { should == false }
#    its(:value?) { should == false }
#
#    its(:error)  { should == 2 }
#
#    it 'fails for :value' do
#      ->{ subject.value }.should raise_error(NoMethodError)
#    end
#
#    it 'defines shortcut' do
#      Lego.fail(1).should be_error(1)
#    end
#  end
#
#  describe '#next' do
#    let(:callable) do
#      ->(err) { fail 'Do not call me' }
#    end
#
#    it 'does not call callable' do
#      ->{ subject.next(callable) }.should_not raise_error
#    end
#
#    it 'returns self' do
#      subject.next(callable).should eql(subject)
#    end
#  end
#
#end
