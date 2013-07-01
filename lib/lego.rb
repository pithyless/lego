require 'equalizer'

module Lego
  require_relative 'lego/left'
  require_relative 'lego/right'
  require_relative 'lego/struct'
  require_relative 'lego/chain'

  def self.left(value)
    Left.new(value)
  end

  def self.right(value)
    Right.new(value)
  end

  def self.fail(value)
    Left.new(value)
  end

  def self.pass(value)
    Right.new(value)
  end
end
