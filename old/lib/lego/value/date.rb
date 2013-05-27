#module Lego::Value
#  class Date < Base
#
#    def parsers
#      [
#        ->(v) { Lego.just(v.to_date) rescue Lego.fail("invalid date: '#{v}'") },
#        ->(v) { v.nil? ? Lego.none : Lego.just(v) },
#      ]
#    end
#
#  end
#end
