module Legit
  module Values

    class ArrayValue < Value

      public_class_method :new

      def initialize(opts={})
        @string_split = opts.delete(:split)
        @element_parser = opts.delete(:element) or fail 'Missing :element parser'
        super
      end

      def parse(value)
        val = parseWith(super, :parse_split)
        val = parseWith(val, :parse_array)
        val = parseWith(val, :parse_empty)
        val = parseWith(val, :parse_elements)
      end

      private

      attr_reader :string_split, :element_parser

      def parse_split(value)
        if value.kind_of?(String) and string_split
          v = Success(Just(value.strip.split(string_split)))
        else
          Success(Just(value))
        end
      end

      def parse_array(value)
        if value.nil?
          Success(Just([]))
        elsif value.kind_of?(Array)
          Success(Just(value))
        else
          Failure("not an array: #{value.inspect}")
        end
      end

      def parse_elements(value)
        parser = element_parser.kind_of?(Class) ? element_parser.new : element_parser
        errs, vals = [], []
        value.each do |val|
          parser.user_value = val
          res = parser.parse_and_validate
          if res.failure?
            errs << "#{val}: #{res.failure}"
          elsif res.success.nothing?
            errs << "Empty value in array: #{val}"
          else
            vals << res.success.value
          end
        end

        errs.any? ? Failure(errs) : Success(Just(vals))
      end

    end

  end
end
