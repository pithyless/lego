module Lego
  class List < Monad

    class << self
      def unit(value)
        new(Array(value))
      end
    end

    def bind(callable=nil, &block)
      callable ||= block
      self.class.unit(@value.map(&callable).flatten(1))
    end

    def join
      self.class.unit(@value.flatten(1))
    end

    def fmap(callable=nil, &block)
      callable ||= block
      self.class.unit(@value.map(&callable))
    end

  end
end
