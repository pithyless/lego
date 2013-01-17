require 'active_support/core_ext/string'
require 'active_support/core_ext/time/conversions'

module Lego
  module Value
  end
end

require_relative 'value/base'
require_relative 'value/set'
require_relative 'value/string'
require_relative 'value/date'
require_relative 'value/integer'
require_relative 'value/float'
require_relative 'value/boolean'
