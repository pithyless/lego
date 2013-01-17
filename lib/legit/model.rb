module Legit
  class Model
    class << self

      def attribute(attr, type, *args)
        parsers[attr.to_sym] = Legit.value_parser(type, *args)
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
          value = attrs.delete(name)
          begin
            h[name] = parser.coerce(value)
          rescue Legit::CoerceError => e
            fail ArgumentError, ":#{name} => #{e.message}"
          end
        end
      end.freeze
      fail ArgumentError, "Unknown attributes: #{attrs}" unless attrs.empty?
    end

    attr_reader :attributes

    def method_missing(name, *args, &block)
      attributes.fetch(name.to_sym) { super }
    end

    def self.coerce(hash)
      hash.instance_of?(self) ? hash : self.new(hash)
    end

    def self.parse(hash)
      Legit.just(self.coerce(hash))
    rescue Legit::CoerceError => e
      Legit.fail(e.message)
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
