require 'active_support/json/encoding'
require 'active_support/core_ext/hash'
require 'equalizer'
require 'abstract_type'

module Lego

  module Eitherish
    def Success(v); Lego::Success.new(v); end
    def Failure(e); Lego::Failure.new(e); end
  end


  class Violation
    include AbstractType
    include Equalizer.new(:name, :value)

    def initialize(value)
      @value ||= value
    end

    attr_reader :value

    def name
      @name ||= self.class.name.split('::').last.underscore
    end

    def error_messages
      [ message ]
    end

    abstract_method :message

    class Coercion < self
      include Equalizer.new(:name, :value, :type)

      def initialize(type, value)
        @type ||= type
        super(value)
      end

      attr_reader :type

      def message
        "cannot be coerced to #{type}"
      end
    end

    class KeyCollection < self
      def error_messages
        value.each_with_object({}) do |(k,v), h|
          h[k] = v.error.error_messages if v.error?
        end
      end
    end

    class Collection < self
    end

    class Blank < self
      def message
        "cannot be blank"
      end
    end
  end


  class Model
    class << self
      def key(name, parser)
        parser = parser.new if parser.kind_of?(Class)
        _schema[name.to_sym] = parser
      end

      def parser
        @parser ||= Lego::Parse::Schema.new(_schema)
      end

      def _schema
        @_schema ||= {}
      end

      def valid?(params)
        parser.call(params).value?
      end
    end
  end


  class Parse
    include AbstractType
    include Lego::Eitherish

    abstract_method :parsers

    def call(value)
      result = Success(value)
      parsers.each { |parser| result = result.bind(parser) }
      result
    end

    class String < self
      def parsers
        [
          ->(v) { v.respond_to?(:to_str) ? Success(v.to_str) : Failure(Violation::Coercion.new(:string, v)) },
          ->(v) { v.blank? ? Failure(Violation::Blank.new(v)) : Success(v) }
        ]
      end
    end

    class Integer < self
      def parsers
        [
          ->(v) { parse_integer(v) }
        ]
      end

      private

      def parse_integer(value)
        Success(Integer(value))
      rescue TypeError, ArgumentError
        Failure(Violation::Coercion.new(:integer, value))
      end
    end

    class Array < self
      def initialize(item_parser, opts={})
        @item_parser = item_parser
      end

      def parsers
        [
          ->(v) { parse_array(v) },
          ->(v) { parse_items(v) }
        ]
      end

      attr_reader :item_parser

      def parse_array(v)
        Success(v.to_ary)
      rescue NoMethodError
        Failure(Violation::Coercion.new(:array, v))
      end

      def parse_items(items)
        result = items.map do |item|
          item_parser.call(item)
        end

        if result.all?(&:value?)
          Success(result.map(&:value))
        else
          Failure(Violation::Collection.new(result))
        end
      end
    end


    class Schema < self
      def initialize(schema)
        @schema = schema.symbolize_keys
      end

      attr_reader :schema

      def parsers
        [
          ->(v) { parse_hash(v) },
          ->(v) { parse_each(v) }
        ]
      end

      private

      def parse_hash(v)
        Success(v.to_h)
      rescue NoMethodError
        Failure(Violation::Coercion.new(:hash, v))
      end

      def parse_each(data)
        result = {}
        schema.each do |name, parser|
          result[name] = parser.call(data[name])
        end

        if result.values.all?(&:value?)
          Success(result.each_with_object({}) do |(k,v), h|
            h[k] = v.value
          end)
        else
          Failure(Violation::KeyCollection.new(result))
        end
      end
    end
  end

  class Either
    include AbstractType

    def value?
      is_a? Success
    end

    def error?
      is_a? Failure
    end

    def fetch(&block)
      value? ? value : block.call(error)
    end
  end

  class Success < Either
    include Equalizer.new(:value)

    def initialize(value)
      @value = value
    end

    attr_reader :value

    def bind(callable=nil, &block)
      callable ||= block
      callable.call(fetch).tap do |v|
        unless v.is_a? Either
          fail TypeError, "Expected Lego::Success or Lego::Failure: #{v.inspect}"
        end
      end
    end
  end

  class Failure < Either
    include Equalizer.new(:error)

    def initialize(error)
      @error = error
    end

    attr_reader :error

    def bind(callable=nil, &block)
      self
    end
  end

end

  # Identity.unit('foo').bind {|v| Identity.unit(v.capitalize) }
  #
  # Lego::Violation::Blank
  # Lego::Violation::Coercion
  # Lego::Violation::Length
  # Lego::Violation::Inclusion
  #
  # BlankViolation
  # CoerceViolation
  # MinLengthViolation
  # MaxLengthViolation
  # LengthViolation
  #
  # Lego.success('Bob').
  #   bind ->(v){ v.respond_to?(:to_str) ? Lego.success(v.to_str) : Lego.failure(CoerceError.new(:string, v)) }.
  #   bind ->(v){ v.blank? ? Lego.failure(BlankError.new(v)) : Lego.success(v) }

#  class Either
#    include Equalizer.new(:value, :error)
#    def initialize(value, error)
#      @value, @error = value, error
#    end
#    attr_reader :value, :error
#  end
#
#
#



#  class ModelError < ValueError
#    def name; :model; end
#  end
#
#

#  class ModelParser
#    def initialize(parsers, data={})
#      parsers = Array(parsers)
#      data = data.symbolize_keys
#      @parsers, @data = parsers, data
#    end
#
#    attr_reader :parsers, :data
#
#    def valid?
#      validate.instance_of?(Lego::Either::Value)
#    end
#
#    def validate
#      p data
#      res = {}
#      parsers.each do |name, parser|
#        res[name] = Lego::Either::Chain.new(parser).call(Lego.value(data.fetch(name)))
#      end
#
#      if res.values.all?{ |v| Lego.value?(v) }
#        unbox = {}.tap do |h| res.each{ |k,v| h[k] = v.value } end
#        Lego.value(unbox)
#      else
#        unbox = {}.tap do |h| res.each{ |k,v| h[k] = Lego.value?(v) ? v.value : v.error } end
#        Lego.error(ModelError.new(unbox))
#      end
#    end
#  end
#
#  def self.value?(value_or_error)
#    value_or_error.instance_of?(Lego::Either::Value)
#  end
#
#  class Model
#    class << self
#      def attr(name, parser)
#        parsers[name.to_sym] = parser
#      end
#
#      def parsers
#        @_parsers ||= {}
#      end
#    end
#
#    def call(data={})
#      ModelParser.new(self.class.parsers, data).validate
#    end
#  end
#
#
#
#
##  class V
##
##  CoerceError = Class.new(StandardError)
##
##  require_relative 'lego/either'
##  require_relative 'lego/value'
##  require_relative 'lego/model'
##
##  def self.value_parser(item, *args)
##    if (Lego::Value.const_defined?(item.to_s, false) rescue false)
##      Lego::Value.const_get(item.to_s, false).new(*args)
##    elsif item.respond_to?(:coerce)
##      item
##    else
##      raise NameError
##    end
##  rescue NameError
##    raise NameError, "Unknown Lego::Value parser: #{item.to_s}"
##  end
##
#end
