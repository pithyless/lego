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

      def cleaned_data
        @cleaned_data ||= {}
      end

      def errors
        @errors ||= {}
      end

      def validate
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

        if errs.empty?
          @cleaned_data, @errors = vals, {}
        else
          @cleaned_data, @errors = {}, errs
        end
      end

    end

  end
end
