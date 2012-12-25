module Legit
  class Immutable
    class << self
      def attributes(*attrs)
        @_attribute_names = attrs.map(&:to_sym).uniq.sort.freeze
      end

      def attribute_names
        @_attribute_names ||= []
      end
    end

    def initialize(attrs={})
      @_attrs = {}.tap do |h|
        self.class.attribute_names.each do |name|
          h[name] = attrs[name]
        end
      end.freeze
    end

    def attributes
      @_attrs
    end

    def method_missing(name, *args, &block)
      @_attrs.fetch(name.to_sym) { super }
    end

    # Equality

    def ==(o)
      o.class == self.class && o.attributes == attributes
    end
    alias_method :eql?, :==

    def hash
      attributes.hash
    end
  end
end
