module Lego::Value
  class String < Base

    def parsers
      [
       ->(v) { v.respond_to?(:to_str) ? Lego.just(v.to_str) : Lego.fail(Lego::Error.new(:not_a_string, v)) },
       ->(v) { strip? ? Lego.just(v.strip) : Lego.just(v) },
       ->(v) { (not allow_blank? and v.blank?) ? Lego.none : Lego.just(v) },
       ->(v) { check_regexp? ? assert_regexp(v) : Lego.just(v) },
       ->(v) { whitelist? ? assert_whitelist(v) : Lego.just(v) }
      ]
    end

    def allow_blank?
      @opts.fetch(:allow_blank, false)
    end

    def strip?
      @opts.fetch(:strip, true)
    end

    def whitelist?
      !!@opts.fetch(:allow, false)
    end

    private

    def check_regexp?
      @opts.key?(:matches)
    end

    def assert_regexp(v)
      regex = @opts.fetch(:matches)
      if regex =~ v
        Lego.just(v)
      else
        Lego.fail(Lego::RegexpValidationError.new(v))
      end
    end

    def assert_whitelist(v)
      whitelist = Array(@opts.fetch(:allow))
      if whitelist.include?(v)
        Lego.just(v)
      else
        Lego.fail(Lego::InclusionValidationError.new(v))
      end
    end

  end
end
