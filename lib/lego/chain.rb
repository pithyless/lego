
module Lego
  class Chain
    def initialize(callables=[])
      @callables = callables
    end

    def bind(&block)
      self.class.new(@callables + [block.to_proc])
    end

    def call(input)
      value = input
      @callables.each do |callable|
        next if value.left?
        value = callable.call(value.right)
      end
      value
    end
  end
end
