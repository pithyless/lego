module Legit
  module Values

    class BooleanValue < Value

      public_class_method :new

      def initialize(opts={})
        super
      end

      def parse(value)
        val = parseWith(super, :parse_empty)
        val = parseWith(val, :parse_boolean)
      end

      def validate(value)
        super
      end

      def value_is_empty?(value)
        value.nil?
      end

      private

      def parse_boolean(value)
        case value
        when true, '1', 'true'
          Success(Just(true))
        when false, '0', 'false'
          Success(Just(false))
        else
          Failure("unrecognized boolean value: #{value.inspect}")
        end
      end

    end

  end
end
