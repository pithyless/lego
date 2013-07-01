module Lego
  class Struct < Module
    def initialize(*keys)
      define_method(:initialize) do |opts={}|
        memory = {}
        keys.each do |attr|
          memory[attr] = opts[attr]
          # TODO: fail if opts includes unkown keys
        end
        @__lego_memory = IceNine.deep_freeze(memory)
      end

      keys.each do |attr|
        define_method(attr) do
          @__lego_memory[attr]
        end
      end

      define_method(:attributes) do
        @__lego_memory
      end

      define_method(:eql?) do |other|
        self.class == other.class && self.attributes == other.attributes
      end

      alias_method :==, :eql?

      define_method(:hash) do
        attributes.hash
      end
    end
  end
end
