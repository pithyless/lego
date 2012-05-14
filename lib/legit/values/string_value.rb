module Legit
  module Values

    class StringValue < Value

      public_class_method :new

      def initialize(opts={})
        @strip = opts.delete(:strip) { false }
        @downcase = opts.delete(:downcase) { false }
        @upcase = opts.delete(:upcase) { false }

        super
      end

      def parse(value)
        val = parseWith(super, :parse_string)
        val = parseWith(val, :parse_strip)
        val = parseWith(val, :parse_empty)
        val = parseWith(val, :parse_downcase)
        val = parseWith(val, :parse_upcase)
      end

      def validate(value)
        super
      end

      private

      def strip?
        @strip
      end

      def downcase?
        @downcase
      end

      def upcase?
        @upcase
      end

      def parse_string(value)
        if value.kind_of?(String)
          Success(Just(value))
        else
          Failure("not a string: #{value}")
        end
      end

      def parse_strip(value)
        strip? ? Success(Just(value.strip)) : Success(Just(value))
      end

      def parse_downcase(value)
        downcase? ? Success(Just(value.downcase)) : Success(Just(value))
      end

      def parse_upcase(value)
        upcase? ? Success(Just(value.upcase)) : Success(Just(value))
      end

    end

  end
end
