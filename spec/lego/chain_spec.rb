require 'spec_helper'
require 'date'

describe Lego::Chain do

  let(:date_parser) do
    ->(input) {
      begin
        Lego.pass(Date.parse(input))
      rescue ArgumentError
        Lego.fail("invalid date: #{input}")
      end
    }
  end

  let(:runner) do
    Lego::Chain.
      chain(date_parser).
      chain( ->(date){ Lego.pass(date + 4) } ).
      chain do |date|
        if date > today
          Lego.pass(date)
        else
          Lego.fail('date in the past')
        end
      end.chain{ |date| Lego.pass(date.strftime('%d-%m-%Y')) }
  end

  subject { runner }

  context 'date in the future' do
    let(:today) { Date.new(2013, 01, 01) }

    it 'parses date' do
      runner.call(Lego.pass('2013-02-07')).value.should == '11-02-2013'
    end

    it 'returns error for invalid date' do
      runner.call(Lego.pass('2013-02')).error.should == 'invalid date: 2013-02'
    end
  end

  context 'date in the future' do
    let(:today) { Date.new(2013, 12, 12) }

    it 'returns error for invalid date' do
      runner.call(Lego.pass('2013-02-07')).error.should == 'date in the past'
    end
  end
end
