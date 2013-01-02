module Legit::Value
  class Base

    def parse(val)
      val = val.nil? ? Legit.none : Legit.just(val)

      parsers.each do |callable|
        val = val.next(callable)
      end
      val
    end

  end
end
