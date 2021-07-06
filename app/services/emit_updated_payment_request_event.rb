# frozen_string_literal: true

class EmitUpdatedPaymentRequestEvent < BaseService
  def initialize(payment_request)
    self.payment_request = payment_request
  end

  def call
    WaterDrop::AsyncProducer.call(
      {
        "id" => payment_request.id,
        "status" => payment_request.status
      }.to_json,
      topic: "payment_request_updated")
  end

  private

  attr_accessor :payment_request
end
