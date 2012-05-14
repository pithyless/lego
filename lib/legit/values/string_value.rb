module Legit
  module Values

    class StringValue < Value

      public_class_method :new

      def initialize(opts={})
        @strip = opts.delete(:strip) { false }
        @downcase = opts.delete(:downcase) { false }
        @upcase = opts.delete(:upcase) { false }
        @regexp = opts.delete(:regexp)
        @min_length = opts.delete(:min_length)
        @max_length = opts.delete(:max_length)

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
        val = validateWith(super, :check_regexp)
        val = validateWith(val, :check_min_length)
        val = validateWith(val, :check_max_length)
      end

      private

      attr_reader :regexp, :min_length, :max_length

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

      def check_regexp(value)
        return Success(Just(value)) if regexp.nil?

        regexp.match(value) ? Success(Just(value)) : Failure('does not match allowed format')
      end

      def check_min_length(value)
        if min_length and value.length < min_length
          Failure("must be at least #{min_length} characters")
        else
          Success(Just(value))
        end
      end

      def check_max_length(value)
        if max_length and value.length > max_length
          Failure("must be at most #{max_length} characters")
        else
          Success(Just(value))
        end
      end


    end

  end
end
