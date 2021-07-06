# frozen_string_literal: true

class CreatedPaymentRequestConsumer < ApplicationConsumer
  def consume
    PaymentRequest.create!(parsed_params)
  end

  private

  def parsed_params
    params.payload
  end
end
