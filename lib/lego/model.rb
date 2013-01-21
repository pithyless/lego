require 'active_support/core_ext/hash/deep_merge'

module Lego
  class Model
    private_class_method :new

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
        res = parse(hash)
        res.value? ? res.value : fail(ArgumentError, res.error.inspect)
      end

      def parse(hash)
        return Lego.just(hash) if hash.instance_of?(self)

        fail ArgumentError, "attrs must be hash: '#{hash.inspect}'" unless hash.respond_to?(:key?)

        result = _parse(hash)

        if result.value?
          model = new(result.value)
          _validate(model)
        else
          result
        end
      end

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

      def _parse(data)
        data = data.dup

        attrs = {}

        parsers.each do |name, parser|
          name = name.to_sym
          value = data.key?(name) ? data.delete(name) : data.delete(name.to_s)

          attrs[name] = parser.parse(value)
        end

        fail ArgumentError, "Unknown attributes: #{data}" unless data.empty?

        if attrs.all?{ |k,v| v.value? }
          Lego.just(Hash[*attrs.map{ |k,v| [k, v.value] }.flatten])
        else
          Lego.fail(Hash[*attrs.map{ |k,v| [k, v.error] if v.error? }.compact.flatten])
        end
      end
    end

    def initialize(attrs={})
      @attributes = attrs.freeze
    end

    attr_reader :attributes

    def merge(other)
      self.class.coerce(as_json.deep_merge(other))
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
