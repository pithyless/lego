module Legit
  module Values

    class IntegerValue < Value

      public_class_method :new

      def initialize(opts={})
        min_value = opts.delete(:min)
        max_value = opts.delete(:max)
        @min_value = Integer(min_value) if min_value
        @max_value = Integer(max_value) if max_value

        super
      end

      def parse(value)
        val = parseWith(super, :parse_empty)
        val = parseWith(val, :parse_integer)
      end

      def validate(value)
        value = validateWith(super, :check_min)
        validateWith(value, :check_max)
      end

      def value_is_empty?(value)
        super or value.to_s.strip.empty?
      end

      private

      attr_reader :min_value, :max_value

      def parse_integer(value)
        Success(Just(Integer(value)))
      rescue ArgumentError, TypeError
        Failure("not an integer")
      end

      def check_min(value)
        if min_value and value < min_value
          Failure("must be at least #{min_value}")
        else
          Success(Just(value))
        end
      end

      def check_max(value)
        if max_value and value > max_value
          Failure("must be at most #{max_value}")
        else
          Success(Just(value))
        end
      end

    end

  end
end
