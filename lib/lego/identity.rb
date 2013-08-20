module Lego
  class Identity < Monad

    def self.unit(value)
      new(value)
    end

  end
end
