module Legit
  CoerceError = Class.new(StandardError)

  require_relative 'legit/either'
  require_relative 'legit/value'
  require_relative 'legit/model'
end
