require 'equalizer'

module Lego
  require_relative 'lego/left'
  require_relative 'lego/right'

  def self.left(value)
    ::Lego::Left.new(value)
  end

  def self.right(value)
    ::Lego::Right.new(value)
  end
end
