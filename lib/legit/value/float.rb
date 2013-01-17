module Legit::Value
  class Float < Base

    def parsers
      [
       ->(v) { v.to_s.empty? ? Legit.none : Legit.just(v) },
       ->(v) { Legit.just(Float(v.to_s)) rescue Legit.fail("invalid float: '#{v}'") },
       ->(v) { v < minimum ? Legit.fail("less than minimum of #{minimum}: '#{v}'") : Legit.just(v) },
       ->(v) { v > maximum ? Legit.fail("more than maximum of #{maximum}: '#{v}'") : Legit.just(v) },
      ]
    end

    def minimum
      @opts.fetch(:min, -1.0/0)
    end

    def maximum
      @opts.fetch(:max, 1.0/0)
    end

  end
end
