module Lego::Value
  class Hash < Base
    def parsers
      [
        ->(v) { v.respond_to?(:to_hash) ? Lego.just(v.to_hash.freeze) : Lego.fail("invalid hash: #{v.inspect}") },
        ->(v) { (not allow_empty? and v.empty?) ? Lego.none : Lego.just(v) }
      ]
    end

    private

    def allow_empty?
      @opts.fetch(:allow_empty, false)
    end
  end
end
