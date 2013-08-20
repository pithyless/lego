require 'spec_helper'

shared_examples 'a monad' do

  describe 'axioms' do
    it '1st monadic law: left-identity' do
      monad.unit(id).bind{ |x| fx.call(x) }.should == monad.unit(fx.call(id))
    end

    it '2nd monadic law: right-identy - unit and bind do not change the value' do
      monad.unit(id).bind do |value|
        value
      end.should == monad.unit(id)
    end

    it '3rd monadic law: associativity' do
      one = monad.unit(id).bind do |x|
        fx.call(x)
      end.bind do |y|
        gx.call(y)
      end

      two = monad.unit(id).bind do |x|
        monad.unit(fx.call(x)).bind do |y|
          gx.call(y)
        end
      end

      one.should == two
    end
  end

end
