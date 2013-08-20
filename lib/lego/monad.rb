module Lego
  class Monad
    include AbstractType

    private_class_method :new

    def initialize(value)
      @value = value
    end


    # Monad

    # self.unit :: (Monad m) => a -> m a

    # join :: (Monad m) => m (m a) -> m a

    # bind :: (Monad m) => m a -> (a -> m b) -> m b
    def bind(callable=nil, &block)
      callable ||= block
      fmap(callable).join
    end

    # liftM :: (Monad m) => (a -> b) -> m a -> m b
    def liftM(callable=nil, &block)
      callable ||= block
      bind(->(x){ callable.call(x) })
    end


    # Functor

    # fmap :: (Functor f) => (a -> b) -> f a -> f b


    def ==(other)
      self.class == other.class && self.value == other.value
    end

    protected

    attr_reader :value
  end
end
