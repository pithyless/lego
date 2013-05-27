module Lego
  class Right
    include Equalizer.new(:right)

    def initialize(right)
      @right = right
    end

    attr_reader :right

    def left?
      false
    end

    def right?
      true
    end
  end
end
