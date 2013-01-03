module Legit
  CoerceError = Class.new(StandardError)

  require_relative 'legit/immutable'
  require_relative 'legit/either'
  require_relative 'legit/value'
end
