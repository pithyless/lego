module Lego
  class Left
    include Equalizer.new(:left)

    def initialize(left)
      @left = left
    end

    attr_reader :left

    def left?
      true
    end

    def right?
      false
    end
  end
end
