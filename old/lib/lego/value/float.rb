#module Lego::Value
#  class Float < Base
#
#    def parsers
#      [
#       ->(v) { v.to_s.empty? ? Lego.none : Lego.just(v) },
#       ->(v) { Lego.just(Float(v.to_s)) rescue Lego.fail("invalid float: '#{v}'") },
#       ->(v) { v < minimum ? Lego.fail("less than minimum of #{minimum}: '#{v}'") : Lego.just(v) },
#       ->(v) { v > maximum ? Lego.fail("more than maximum of #{maximum}: '#{v}'") : Lego.just(v) },
#      ]
#    end
#
#    def minimum
#      @opts.fetch(:min, -1.0/0)
#    end
#
#    def maximum
#      @opts.fetch(:max, 1.0/0)
#    end
#
#  end
#end
