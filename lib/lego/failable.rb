module Lego

  module Success
    include Equalizer.new(:value)

    def initialize(value)
      @value = value
    end

    attr_reader :value

    def value?; true; end
    def error?; false; end

    def fetch(&block)
      value
    end

    protected

    def verify_value(value)
      unless value.respond_to?(:value?) && value.respond_to?(:error?)
        fail TypeError, "Expected Lego::Success or Lego::Failure: #{value.inspect}"
      end
    end
  end

  module Failure
    include Equalizer.new(:error)

    def initialize(error)
      @error = error
    end

    attr_reader :error

    def value?; false; end
    def error?; true; end

    def fetch(&block)
      if block_given?
        block.call(error)
      else
        fail "Could not fetch failure: #{self.inspect}"
      end
    end

    def bind(callable=nil, &block)
      self
    end
  end

  class ValueSuccess
    include Success

    def bind(callable=nil, &block)
      callable ||= block
      callable.call(value).tap{ |v| verify_value(v) }
    end
  end

  class ValueFailure
    include Failure
  end

  class SchemaSuccess
    include Success

    def bind(callable=nil, &block)
      callable ||= block
      value.each do |key, val|
        key
      end
      callable.call(value).tap{ |v| verify_value(v) }
    end
  end

  class SchemaFailure
    include Failure
  end

end
