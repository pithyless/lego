module Lego
  class Left
    def initialize(value)
      @value = value
    end

    def left
      @value
    end

    def left?
      true
    end

    def right?
      false
    end
  end
end
