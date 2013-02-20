require 'active_support/json/encoding'
require 'active_support/core_ext/hash'
require 'equalizer'

module Lego

  module Either
    class Value
      def initialize(value)
        @value = value
      end
      attr_reader :value
    end

    class Error
      def initialize(error)
        @error = error
      end
      attr_reader :error
    end

    class Chain
      def initialize(callables)
        @callables = Array(callables)
      end

      def call(maybe_value)
        check_value(maybe_value)
        @callables.each do |callable|
          return maybe_value if maybe_value.instance_of?(Lego::Either::Error)
          maybe_value = callable.call(maybe_value.value).tap{ |v| check_value(v) }
        end
        maybe_value
      end

      private

      def check_value(value)
        unless value.instance_of?(Lego::Either::Value) or value.instance_of?(Lego::Either::Error)
          raise TypeError, "Not Lego::Either: #{value.inspect}"
        end
      end
    end
  end

  def self.value(value)
    Lego::Either::Value.new(value)
  end

  def self.error(error)
    Lego::Either::Error.new(error)
  end


  class ValueError
    include Equalizer.new(:name, :value)
    def initialize(value)
      @value = value
    end
    attr_reader :value

    def name; :invalid; end
  end

  class CoerceError < ValueError
    include Equalizer.new(:name, :value, :type)
    def initialize(type, value)
      super(value)
      @type = type
    end
    attr_reader :type

    def name; :coercion; end
  end

  class BlankError < ValueError
    def name; :blank; end
  end

  class ModelError < ValueError
    def name; :model; end
  end


  class StringParser
    def parsers
      [
       ->(v) { v.respond_to?(:to_str) ? Lego.value(v.to_str) : Lego.error(CoerceError.new(:string, v)) },
       ->(v) { v.blank? ? Lego.error(BlankError.new(v)) : Lego.value(v) }
      ]
    end

    def call(value)
      Lego::Either::Chain.new(parsers).call(Lego.value(value))
    end
  end

  class ModelParser
    def initialize(parsers, data={})
      parsers = Array(parsers)
      data = data.symbolize_keys
      @parsers, @data = parsers, data
    end

    attr_reader :parsers, :data

    def valid?
      validate.instance_of?(Lego::Either::Value)
    end

    def validate
      p data
      res = {}
      parsers.each do |name, parser|
        res[name] = Lego::Either::Chain.new(parser).call(Lego.value(data.fetch(name)))
      end

      if res.values.all?{ |v| Lego.value?(v) }
        unbox = {}.tap do |h| res.each{ |k,v| h[k] = v.value } end
        Lego.value(unbox)
      else
        unbox = {}.tap do |h| res.each{ |k,v| h[k] = Lego.value?(v) ? v.value : v.error } end
        Lego.error(ModelError.new(unbox))
      end
    end
  end

  def self.value?(value_or_error)
    value_or_error.instance_of?(Lego::Either::Value)
  end

  class Model
    class << self
      def attr(name, parser)
        parsers[name.to_sym] = parser
      end

      def parsers
        @_parsers ||= {}
      end
    end

    def call(data={})
      ModelParser.new(self.class.parsers, data).validate
    end
  end




#  class V
#
#  CoerceError = Class.new(StandardError)
#
#  require_relative 'lego/either'
#  require_relative 'lego/value'
#  require_relative 'lego/model'
#
#  def self.value_parser(item, *args)
#    if (Lego::Value.const_defined?(item.to_s, false) rescue false)
#      Lego::Value.const_get(item.to_s, false).new(*args)
#    elsif item.respond_to?(:coerce)
#      item
#    else
#      raise NameError
#    end
#  rescue NameError
#    raise NameError, "Unknown Lego::Value parser: #{item.to_s}"
#  end
#
end
