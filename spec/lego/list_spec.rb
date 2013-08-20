require 'spec_helper'

describe Lego::List, :focus do
  let(:monad) { Lego::List }

  it_behaves_like 'a monad' do
    let(:id) { [10, 20] }
    let(:fx) { ->(x){ [x] } }
    let(:gx) { ->(y){ [y, y + 1] } }
  end

  it '#join' do
    monad.unit([10, [20, 30, [40, 50]]]).join.should == monad.unit([10, 20, 30, [40, 50]])
  end

  it '#bind' do
    monad.unit([10, 20, 30]).bind do |x|
      [x, x + 1]
    end.should == monad.unit([10, 11, 20, 21, 30, 31])

    monad.unit([10, 20, 30]).bind do |x|
      [x, x + 1]
    end.bind do |y|
      y > 20 ? [] : [y, y]
    end.should == monad.unit([10, 10, 11, 11, 20, 20])
  end

  it '#liftM' do
    monad.unit([10, 20, 30]).liftM do |x|
      x.to_s
    end.should == monad.unit(%w{10 20 30})
  end
end
