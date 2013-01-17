module Lego
  require 'active_support/json/encoding'

  CoerceError = Class.new(StandardError)

  require_relative 'lego/either'
  require_relative 'lego/value'
  require_relative 'lego/model'

  def self.value_parser(item, *args)
    if item.is_a?(Symbol)
      Lego::Value.const_get(item.to_s.camelize, false).new(*args)
    elsif item.respond_to?(:coerce)
      item
    else
      fail NameError
    end
  rescue NameError
    fail NameError, "Unknown Lego::Value parser: #{item.to_s.camelize}"
  end

end
