module Lego
  class Chain
    def initialize(callables=[])
      @callables = callables
    end

    class << self
      def chain(callable=nil, &block)
        callable ||= block.to_proc
        new([callable])
      end
    end

    def chain(callable=nil, &block)
      callable ||= block.to_proc
      self.class.new(@callables + [callable])
    end

    def call(input)
      item = input
      @callables.each do |callable|
        next unless item.value?
        item = callable.call(item.value)
      end
      item
    end
  end
end
