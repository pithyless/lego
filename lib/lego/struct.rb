module Lego
  module Struct

    def self.new(*keys)
      keys = keys.map(&:to_sym)

      Class.new.tap do |klass|
        klass.instance_eval do |obj|
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

          define_method(:to_h) do
            @__lego_memory
          end

          define_method(:eql?) do |other|
            self.class == other.class && self.to_h == other.to_h
          end

          alias_method :==, :eql?

          define_method(:hash) do
            to_h.hash
          end

          obj.class.define_method(:attributes) do
            keys.sort
          end
        end
      end
    end

  end
end

