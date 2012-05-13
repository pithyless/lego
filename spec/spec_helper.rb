require_relative '../lib/legit'

RSpec::Matchers.define :be_success_nothing do
  match do |actual|
    actual.success? and actual.success.nothing?
  end

  failure_message_for_should do |actual|
    if not actual.kind_of?(Either)
      "#{actual.inspect} should be Either"
    elsif actual.failure?
      "#{actual.inspect} should be success"
    else
      "#{actual.failure.value.inspect} should be Either::Nothing"
    end
  end
end


RSpec::Matchers.define :be_failure do |expected|
  match do |actual|
    actual.failure? and actual.failure == expected
  end

  failure_message_for_should do |actual|
    if not actual.kind_of?(Either)
      "#{actual.inspect} should be Either"
    elsif actual.success?
      "#{actual.inspect} should be failure"
    else
      "#{actual.failure.inspect} should equal #{expected.inspect}"
    end
  end
end


RSpec::Matchers.define :be_success_just do |expected|
  match do |actual|
    if actual.success? and actual.success.just?
      actual.success.value == expected
    else
      false
    end
  end

  failure_message_for_should do |actual|
    if not actual.kind_of?(Either)
      "#{actual.inspect} should be Either"
    elsif actual.failure?
      "#{actual.inspect} should be success"
    elsif actual.success.nothing?
      "#{actual.inspect} should not be Nothing"
    else
      "#{actual.success.value} should equal #{expected.inspect}"
    end
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
