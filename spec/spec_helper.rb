require_relative '../lib/lego'

RSpec::Matchers.define :be_nothing do
  match do |actual|
    actual.kind_of?(Lego::Either::None)
  end

  failure_message_for_should do |actual|
    "Expected <Lego::None>, not #{actual.inspect}"
  end
end

RSpec::Matchers.define :be_error do |expected|
  match do |actual|
    actual.kind_of?(Lego::Either::Fail) and actual.error == expected
  end

  failure_message_for_should do |actual|
    "Expected <Lego::Either::Fail #{expected.inspect}>, not #{actual.inspect}"
  end
end

RSpec::Matchers.define :be_just do |expected|
  match do |actual|
    actual.kind_of?(Lego::Either::Just) and actual.value == expected
  end

  failure_message_for_should do |actual|
    "Expected <Lego::Either::Just #{expected.inspect}>, not #{actual.inspect}"
  end
end


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
