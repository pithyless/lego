require 'spec_helper'
require 'date'

describe Lego::Chain, :focus do

  let(:runner) do
    Lego::Chain.new.
      bind do |input|
        begin
          date = Date.parse(input)
          Lego.pass(date)
        rescue ArgumentError
          Lego.fail("invalid date: '#{input}'")
        end
      end.
      bind do |date|
        Lego.pass(date + 4)
      end.
      bind do |date|
        Lego.pass(date.strftime('%d-%m-%Y'))
      end
  end

  subject { runner.new }

  it 'parses date' do
    runner.call(Lego.pass('2013-02-07')).right.should == '11-02-2013'
  end
end
