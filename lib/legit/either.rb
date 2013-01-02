module Legit

  def self.none
    Either::None.new
  end

  def self.just(value)
    Either::Just.new(value)
  end

  def self.fail(error)
    Either::Fail.new(error)
  end

  module Either
    module Eitherish
      def value?
        false
      end

      def none?
        false
      end

      def error?
        false
      end

      def next(callable)
        self
      end
    end

    class Just
      include Eitherish

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def value?
        true
      end

      def next(callable)
        callable.call(value).tap do |res|
          unless res.kind_of?(Eitherish)
            fail TypeError, "Not Legit::Either: #{res.inspect}"
          end
        end
      end

      def inspect
        "<Legit::Either::Just #{value}>"
      end
    end

    class None
      include Eitherish

      def none?
        true
      end

      def inspect
        "<Legit::Either::None>"
      end
    end

    class Fail
      include Eitherish

      def initialize(error)
        @error = error
      end

      attr_reader :error

      def error?
        true
      end

      def inspect
        "<Legit::Either::Fail #{error}>"
      end
    end

  end
end
