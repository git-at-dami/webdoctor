# frozen_string_literal: true

module Payments
  class FlakyPaymentProvider
    class PaymentError < StandardError; end

    def debit(amount)
      # This is simulating flaky API on the other side that can sometimes respond with an error
      raise PaymentError, "Failed to charge #{amount}" unless Time.current.to_i.even?

      true
    end
  end
end
