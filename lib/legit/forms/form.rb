module Legit
  module Forms

    class Form
      attr_reader :clean_data, :raw_data, :errors

      def initialize(data={})
        @raw_data = data
        @valid = data.empty? ? false : nil
        @clean_data, @errors = {}, {}
      end

      def valid?
        return @valid unless @valid.nil?
        validate
        @valid = errors.empty?
      end

      def validate_before_fields
        [{}, {}]
      end

      def validate_after_fields
        [{}, {}]
      end

      private

      def validate_fields
        vals, errs = {}, {}

        fields.each do |attr, field|
          field.user_value = raw_data[attr]
          res = field.parse_and_validate
          if res.failure?
            (errs[attr] ||= []) << res.failure.to_s
          elsif res.success.nothing?
            vals[attr] = nil
          else
            vals[attr] = res.success.value
          end
        end

        [vals, errs]
      end

      def validate
        validate_helper(:validate_before_fields)
        validate_helper(:validate_fields)
        validate_helper(:validate_after_fields)
      end

      def validate_helper(sym)
        if errors.empty?
          vals, errs = send(sym)
          if errs.empty?
            @clean_data, @errors = clean_data.merge(vals), {}
          else
            @clean_data, @errors = {}, errors.merge(errs)
          end
        end
      end

    end

  end
end
