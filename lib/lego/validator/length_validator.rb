module Lego
  class LengthValidator

    def initialize(opts={})
      @min = opts[:min]
      @max = opts[:max]
    end

    attr_reader :min, :max

  end
end
