module Legit
  CoerceError = Class.new(StandardError)

  require_relative 'legit/either'
  require_relative 'legit/value'
  require_relative 'legit/model'

  def self.value_parser(item)
    if item.is_a?(Symbol)
      Legit::Value.const_get(item.to_s.camelize, false).new
    elsif item.respond_to?(:coerce)
      item
    else
      fail NameError
    end
  rescue NameError
    fail NameError, "Unknown Legit::Value parser: #{item.to_s.camelize}"
  end

end
