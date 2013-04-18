require 'minitest/spec'
require 'minitest/autorun'
require 'turn'

require 'lego'


MiniTest::Spec.class_eval do
  def self.shared_examples
    @shared_examples ||= {}
  end
end

module MiniTest::Spec::SharedExamples
  def shared_examples_for(desc, &block)
    MiniTest::Spec.shared_examples[desc] = block
  end

  def it_behaves_like(desc)
    self.instance_eval(&MiniTest::Spec.shared_examples[desc])
  end
end

Object.class_eval { include(MiniTest::Spec::SharedExamples) }

module MiniTest::Assertions
  def assert_equals_value_success(value, result)
    assert result.must_be_instance_of(Lego::ValueSuccess)
    assert_equal result, Lego::ValueSuccess.new(value)
  end

  def assert_equals_value_failure(error, result)
    assert result.must_be_instance_of(Lego::ValueFailure)
    assert_equal result, Lego::ValueFailure.new(error)
  end
end

Object.infect_an_assertion :assert_equals_value_success, :must_equal_value_success
Object.infect_an_assertion :assert_equals_value_failure, :must_equal_value_failure
