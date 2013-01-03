module Legit::Value
  class Base
    def initialize(opts={})
      @opts = opts
    end

    def parse(val)
      val = val.nil? ? Legit.none : Legit.just(val)

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
        raise Legit::CoerceError, resp.error
      elsif @opts[:nothing]
        @opts[:nothing].call
      else
        raise Legit::CoerceError, 'Missing required value'
      end
    end

    def parsers
      []
    end

  end
end
