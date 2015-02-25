module Lego::Value
  class Array < Base

    def initialize(type, opts={})
      @_item_parser = Lego.value_parser(type, opts[:children_opts] || {} )
      super(opts)
    end

    def parsers
      [
       ->(v) { v.respond_to?(:to_ary) ? Lego.just(v.to_ary) : Lego.fail("invalid array: '#{v}'") },
       ->(v) { check_length? ? enforce_length(v) : Lego.just(v) },
       ->(v) { parse_items(v) },
       ->(v) { (not allow_empty? and v.empty?) ? Lego.none : Lego.just(v) }
      ]
    end

    private

    def parse_items(items)
      errors = []

      items = items.map do |item|
        new_item = @_item_parser.parse(item)
        if new_item.value?
          errors << nil
          new_item.value
        else
          errors << new_item.error
        end
      end

      if errors.compact.empty?
        Lego.just(items)
      else
        Lego.fail(errors)
      end
    end

    def check_length?
      @opts.key?(:length)
    end

    def allow_empty?
      @opts.fetch(:allow_empty, false)
    end

    def enforce_length(items)
      length = @opts.fetch(:length).to_i
      if items.length == length
        Lego.just(items)
      else
        Lego.fail("length not #{length}: '#{items}'")
      end
    end

  end
end
