module Lego
  class Runner
    def initialize
      @left  = ->(*args){ fail NotImplementedError.new('Missing #left proc') }
      @right = ->(*args){ fail NotImplementedError.new('Missing #right proc') }
    end

    def call(value)
      case value
      when Lego::Left
        @left.call(value.left)
      when Lego::Right
        @right.call(value.right)
      else
        raise ArgumentError.new("Expected Lego::Left or Lego::Right: '#{value.inspect}'")
      end
    end

    def left(&block)
      @left = block
      self
    end

    def right(&block)
      @right = block
      self
    end
  end
end
