module Lego
  class Right
    def initialize(value)
      @value = value
    end

    def right
      @value
    end

    def right?
      true
    end

    def left?
      false
    end
  end
end
