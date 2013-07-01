require 'spec_helper'

describe Lego::Runner do

  context 'control flow' do
    describe '#left' do
      let(:value)       { double }
      let(:left_value)  { double }

      subject do
        Lego::Runner.new.left{ |v| left_value }
      end

      it 'returns Runner (chainable)' do
        subject.should be_instance_of(Lego::Runner)
      end

      it 'calls #left on Left' do
        subject.call(Lego.left(value)).should == left_value
      end

      it 'calls #right on Right' do
        expect{ subject.call(Lego.right(value)) }.to raise_error(NotImplementedError)
      end

      it 'fails on anything else' do
        expect{ subject.call(nil) }.to raise_error(ArgumentError, "Expected Lego::Left or Lego::Right: 'nil'")
      end
    end

    describe '#right' do
      let(:value)       { double }
      let(:right_value)  { double }

      subject do
        Lego::Runner.new.right{ |v| right_value }
      end

      it 'returns Runner (chainable)' do
        subject.should be_instance_of(Lego::Runner)
      end

      it 'calls #right on Right' do
        subject.call(Lego.right(value)).should == right_value
      end

      it 'calls #left on Left' do
        expect{ subject.call(Lego.left(value)) }.to raise_error(NotImplementedError)
      end

      it 'fails on anything else' do
        expect{ subject.call(nil) }.to raise_error(ArgumentError, "Expected Lego::Left or Lego::Right: 'nil'")
      end
    end
  end

  context 'Either monad' do
    let(:left_value) { double }
    let(:left) { Lego.left(left_value) }

    let(:right_value) { 42 }
    let(:right) { Lego.right(right_value) }

    let(:runner) do
      Lego::Runner::Either.new.bind do |value|
        value + 10
      end.bind do |value|
        value + 32
      end
    end

    context 'left value' do
      it 'returns new Lego::Left' do
        runner.call(left).should == left
        runner.call(left).should_not equal(left)
      end
    end

    context 'right value' do
      it 'evaluates success callback' do
        runner.call(right).should == Lego.right(84)
      end
    end
  end

end
