class Maybe
  private_class_method :new

  def initialize(value)
    @value = value
  end

  def nothing?
    @value.nil?
  end

  def just?
    not nothing?
  end

  def value
    fail 'Maybe::Nothing has no value' if nothing?
    @value
  end

  def >=(callable)
    if nothing?
      self
    else
      callable.call(value)
    end
  end
  alias_method :bind, :>=

  def >>(callable)
    if nothing?
      self
    else
      callable.call
    end
  end
  alias_method :chain, :>>

  def self.nothing
    new(nil)
  end

  def self.just(value)
    new(value)
  end

  def inspect
    if nothing?
      "Maybe::Nothing"
    else
      "Maybe::Just(#{value.inspect})"
    end
  end

end

def Just(value)
  Maybe.just(value)
end

def Nothing
  Maybe.nothing
end
