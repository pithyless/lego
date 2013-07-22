require 'equalizer'

module Lego
  require_relative 'lego/struct'
  require_relative 'lego/chain'

  class Success
    def initialize(value)
      @value = value
    end

    def value?
      true
    end

    def value(&block)
      @value
    end

    def error
      fail "Unexpected #error called on Lego::Success <#{value.inspect}>"
    end

    def ==(other)
      self.class == other.class && self.value == other.value
    end
    alias_method :eql?, :==

    def hash
      value.hash
    end
  end

  class Failure
    def initialize(error)
      @error = error
    end

    def value?
      false
    end

    def value(&block)
      block ||= ->(error){ fail "Unexpected #value called on Lego::Failure <#{value.inspect}>" }
      block.call(value)
    end

    def error
      @error
    end

    def ==(other)
      self.class == other.class && self.error == other.error
    end
    alias_method :eql?, :==

    def hash
      error.hash
    end
  end

  def self.fail(error)
    Failure.new(error)
  end

  def self.pass(value)
    Success.new(value)
  end
end
