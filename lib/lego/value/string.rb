module Lego::Value
  class String < Base

    def parsers
      [
       ->(v) { v.respond_to?(:to_str) ? Lego.just(v.to_str) : Lego.fail("invalid string: '#{v}'") },
       ->(v) { strip? ? Lego.just(v.strip) : Lego.just(v) },
       ->(v) { (not allow_blank? and v.blank?) ? Lego.none : Lego.just(v) },
      ]
    end

    def allow_blank?
      @opts.fetch(:allow_blank, false)
    end

    def strip?
      @opts.fetch(:strip, true)
    end
  end
end
