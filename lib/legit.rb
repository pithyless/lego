require_relative 'either'
require_relative 'maybe'

module Legit
  module Values
    autoload :Value,        'legit/values/value'
    autoload :ArrayValue,   'legit/values/array_value'
    autoload :BooleanValue, 'legit/values/boolean_value'
    autoload :IntegerValue, 'legit/values/integer_value'
    autoload :StringValue,  'legit/values/string_value'
  end

  module Forms
    autoload :Form, 'legit/forms/form'
  end
end
