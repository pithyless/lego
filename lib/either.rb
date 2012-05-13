class Either

  attr_reader :failure, :success
  private_class_method :new

  def initialize(failure, success)
    @failure = failure
    @success = success
  end

  def failure?
    !!failure
  end

  def success?
    not failure?
  end

  def >=(callable)
    if failure?
      self
    else
      callable.call(success).tap do |e|
        fail_unless_either(e)
      end
    end
  end
  alias_method :bind, :>=

  def >>(callable)
    if failure?
      self
    else
      callable.call.tap do |e|
        fail_unless_either(e)
      end
    end
  end
  alias_method :chain, :>>

  def self.failure(failure)
    new(failure, nil)
  end

  def self.success(success)
    new(nil, success)
  end

  def self.exec_binds(binds, initial)
    fail_unless_either(initial)
    value = initial
    binds.each do |callable|
      value = value.bind(callable)
    end
  end

  private

  def fail_unless_either(obj)
    fail "Expected Either; got #{obj.inspect}" unless obj.is_a?(Either)
  end

end

def Success(success)
  Either.success(success)
end

def Failure(failure)
  Either.failure(failure)
end
