require 'equalizer'

module Lego
  require_relative 'lego/left'
  require_relative 'lego/right'
  require_relative 'lego/runner'
  require_relative 'lego/value'

  def self.left(value)
    Left.new(value)
  end

  def self.right(value)
    Right.new(value)
  end

  def self.right_or_first_left(&block)
    Runner.new.
      left { |error| Lego.left(error) }.
      right{ |value| Lego.right(block.call(value)) }
  end
end
