module Lego::Value
  class Base

    def initialize(opts={})
      @opts = opts
    end

    def parse(val)
      val = val.nil? ? Lego.none : Lego.just(val)

      parsers.each do |callable|
        val = val.next(callable)
      end

      return val unless val.none?

      if @opts[:default]
        Lego.just(@opts[:default].call)
      else
        Lego.fail('missing value')
      end
    end

    def coerce(val)
      res = parse(val)
      res.value? ? res.value : fail(Lego::CoerceError, res.error)
    end

    def parsers
      []
    end

  end
end
