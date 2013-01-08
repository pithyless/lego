module Legit::Value
  class Date < Base

    def parsers
      [
        ->(v) { Legit.just(v.to_date) rescue Legit.fail("invalid date: '#{v}'") },
        ->(v) { v.nil? ? Legit.none : Legit.just(v) },
      ]
    end

  end
end
