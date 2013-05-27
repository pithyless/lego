module Lego
  class Value < Module
    def initialize(*keys)
      @keys = keys
      define_methods
    end

    private

    def define_methods
      define_initialize_method
      define_reader_methods
      define_equalizer
    end

    def define_initialize_method
      define_method(:initialize) do |opts={}|
        opts ||= {}
        opts.each do |k,v|
          instance_variable_set("@#{k}", v)
        end
      end
    end

    def define_reader_methods
      @keys.each do |key|
        define_method(key) do
          instance_variable_get("@#{key}")
        end
      end
    end

    def define_equalizer
      include Equalizer.new(*@keys)
    end
  end
end
