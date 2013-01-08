module Legit::Value
  class String < Base

    def parsers
      [
       ->(v) { v.respond_to?(:to_str) ? Legit.just(v.to_str) : Legit.fail("invalid string: '#{v}'") },
       ->(v) { strip? ? Legit.just(v.strip) : Legit.just(v) },
       ->(v) { (not allow_blank? and v.blank?) ? Legit.none : Legit.just(v) },
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
