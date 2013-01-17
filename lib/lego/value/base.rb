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
      val
    end

    def coerce(val)
      resp = parse(val)
      if resp.value?
        resp.value
      elsif resp.error?
        raise Lego::CoerceError, resp.error
      elsif @opts[:default]
        @opts[:default].call
      else
        raise Lego::CoerceError, 'missing value'
      end
    end

    def parsers
      []
    end

  end
end
