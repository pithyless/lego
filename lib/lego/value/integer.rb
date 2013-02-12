module Lego::Value
  class Integer < Base

    def parsers
      [
       ->(v) { v.to_s.empty? ? Lego.none : Lego.just(v) },
       ->(v) { Lego.just(Integer(v.to_s)) rescue Lego.fail(Lego::Error.new(:not_an_integer, v)) },
       ->(v) { v < minimum ? Lego.fail("less than minimum of #{minimum}: '#{v}'") : Lego.just(v) },
       ->(v) { v > maximum ? Lego.fail("more than maximum of #{maximum}: '#{v}'") : Lego.just(v) },
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
