require 'spec_helper'

describe Lego::Either::None do

  subject { Lego::Either::None.new }

  its(:none?)  { should == true }
  its(:value?) { should == false }
  its(:error?) { should == false }

  it 'fails for :value' do
    ->{ subject.value }.should raise_error(NoMethodError)
  end

  it 'fails for :error' do
    ->{ subject.error }.should raise_error(NoMethodError)
  end

  it 'defines shortcut' do
    Lego.none.should be_none
  end

  describe '#next' do
    let(:callable) do
      ->(err) { fail 'Do not call me!' }
    end

    it 'does not call callable' do
      ->{ subject.next(callable) }.should_not raise_error
    end

    it 'returns self' do
      subject.next(callable).should eql(subject)
    end
  end

end
