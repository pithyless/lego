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

      def validations
        @_validations ||= []
      end

      def attribute_names
        parsers.keys
      end

      def validates(callable=nil, &block)
        if callable && callable.is_a?(Symbol)
          validations << callable
        else
          validations << block
        end
      end

      def validate(msg, callable)
        if callable.is_a?(Symbol)
          callable_name = callable.to_sym
          validations << ->(v) { v.method(callable_name).call ? Lego.just(v) : Lego.fail(msg) }
        else
          validations << ->(v) { callable.call(v) ? Lego.just(v) : Lego.fail(msg) }
        end
      end

      def coerce(hash)
        obj = hash.instance_of?(self) ? hash : self.new(hash)
        res = _validate(obj)
        res.value? ? res.value : fail(CoerceError, res.error)
      end

      def parse(hash)
        Lego.just(self.coerce(hash))
      rescue Lego::CoerceError => e
        Lego.fail(e.message)
      end

      private

      def _validate(obj)
        res = Lego.just(obj)
        validations.each do |validation|
          if validation.is_a?(Symbol)
            callable_method_name = validation.to_sym
            validation = ->(o){ o.method(callable_method_name).call }
          end
          res = res.next(validation)
        end
        res
      end
    end

    def initialize(attrs={})
      fail ArgumentError, "attrs must be hash: '#{attrs.inspect}'" unless attrs.respond_to?(:key?)
      attrs = attrs.dup
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

    # Equality

    def ==(o)
      o.class == self.class && o.attributes == attributes
    end
    alias_method :eql?, :==

    def hash
      attributes.hash
    end

    # Serialize

    def as_json(opts={})
      raise NotImplementedError, 'as_json with arguments' unless opts.empty?
      {}.tap do |h|
        attributes.each do |attr, val|
          h[attr] = val.as_json
        end
      end
    end
  end
end
