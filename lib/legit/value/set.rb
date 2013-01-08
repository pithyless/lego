require 'set'

module Legit::Value
  class Set < Base

    def initialize(type, opts={})
      @_item_parser = Legit.value_parser(type)
      super(opts)
    end

    def parsers
      [
       ->(v) { v.respond_to?(:to_set) ? Legit.just(v.to_set) : Legit.fail("invalid set: '#{v}'") },
       ->(v) { parse_items(v) },
       ->(v) { (not allow_empty? and v.empty?) ? Legit.none : Legit.just(v) },
      ]
    end

    private

    def parse_items(set)
      new_set = ::Set.new
      set.each do |item|
        new_item = @_item_parser.parse(item)
        if new_item.value?
          new_set << new_item.value
        else
          return new_item
        end
      end
      Legit.just(new_set)
    end

    def allow_empty?
      @opts.fetch(:allow_empty, false)
    end

  end
end
