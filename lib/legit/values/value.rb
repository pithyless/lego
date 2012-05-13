module Legit
  module Values

    class Value
      private_class_method :new

      attr_reader :user_value

      def initialize(opts={})
        @required = opts.fetch(:required, true)
      end

      def value
        @value ||= parse_and_validate
      end

      def user_value=(val)
        @user_value = val
        @value = nil
      end

      def required?
        !!@required
      end

      def parse_and_validate
        value = user_value
        value = value.dup rescue value
        if value.nil? and required?
          Failure("is required")
        else
          parse(Just(value)).bind ->(val){ validate(val) }
        end
      end

      def value_is_empty?(value)
        value.nil? or value.respond_to?(:empty?) && value.empty?
      end

      def parse_empty(value)
        if value_is_empty?(value)
          required? ? Failure("is required") : Success(Nothing())
        else
          Success(Just(value))
        end
      end

      def parse(value)
        Success(value)
      end

      def validate(value)
        Success(value)
      end

      def validateWith(callee, sym)
        callee.bind ->(maybe_val) do
          if maybe_val.nothing?
            Success(maybe_val)
          else
            send(sym, maybe_val.value)
          end
        end
      end

      def parseWith(callee, sym)
        callee.bind ->(maybe_val) do
          if maybe_val.nothing?
            Success(maybe_val)
          else
            send(sym, maybe_val.value)
          end
        end
      end

    end

  end
end
