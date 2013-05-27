module Lego
#  require 'active_support/json/encoding'
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
end
