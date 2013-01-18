require 'active_support/core_ext/hash/deep_merge'

module Lego
  class Model
    class << self

      def attribute(attr, type, *args)
        parsers[attr.to_sym] = Lego.value_parser(type, *args)
      end

      def parsers
        @_parsers ||= {}
      end

      def attribute_names
        parsers.keys
      end
    end

    def initialize(attrs={})
      @attributes = {}.tap do |h|
        self.class.parsers.each do |name, parser|
          name = name.to_sym
          value = attrs.key?(name) ? attrs.delete(name) : attrs.delete(name.to_s)
          begin
            h[name] = parser.coerce(value)
          rescue Lego::CoerceError => e
            fail ArgumentError, ":#{name} => #{e.message}"
          end
        end
      end.freeze
      fail ArgumentError, "Unknown attributes: #{attrs}" unless attrs.empty?
    end

    attr_reader :attributes

    def merge(other)
      self.class.new(as_json.deep_merge(other))
    end

    def method_missing(name, *args, &block)
      attributes.fetch(name.to_sym) { super }
    end

    def self.coerce(hash)
      hash.instance_of?(self) ? hash : self.new(hash)
    end

    def self.parse(hash)
      Lego.just(self.coerce(hash))
    rescue Lego::CoerceError => e
      Lego.fail(e.message)
    end

    # Equality

    def ==(o)
      o.class == self.class && o.attributes == attributes
    end
    alias_method :eql?, :==

    def hash
      attributes.hash
    end

    # Serialize

    def as_json
      {}.tap do |h|
        attributes.each do |attr, val|
          h[attr] = val.as_json
        end
      end
    end
  end
end
