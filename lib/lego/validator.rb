#jrequire 'active_support/core_ext/string'
#jrequire 'active_support/core_ext/time/conversions'


module Lego

  class Error

    def initialize(message, value)
      @message = message
      @value = value
    end

    attr_reader :message

  end


  class Errors

    def errors
      @errors ||= {}
    end

    def add(attribute, error)
      errors[attribute.to_sym] = error
    end

    def any?
      errors.any?
    end

  end

  class RegexpValidationError < Error
    def initialize(value)
      super(:invalid, value)
    end
  end

  class InclusionValidationError < Error
    def initialize(value)
      super(:inclusion, value)
    end
  end


end
