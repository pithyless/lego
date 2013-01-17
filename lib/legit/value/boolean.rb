module Legit::Value
  class Boolean < Base

    def parsers
      [
       ->(v) { parse_boolean(v) }
      ]
    end

    private

    def parse_boolean(v)
      case v
      when true, 'true'
        Legit.just(true)
      when false, 'false'
        Legit.just(false)
      when ''
        Legit.none
      else
        Legit.fail("invalid boolean: '#{v}'")
      end
    end

  end
end
