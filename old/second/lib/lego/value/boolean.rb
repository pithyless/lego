module Lego::Value
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
        Lego.just(true)
      when false, 'false'
        Lego.just(false)
      when ''
        Lego.none
      else
        Lego.fail("invalid boolean: '#{v}'")
      end
    end

  end
end
