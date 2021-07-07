# frozen_string_literal: true

require 'rails_helper'

describe EmitUpdatedPaymentRequestEvent do
  describe ".call" do
    let!(:payment_request) { create :payment_request }
    let(:expected_event_message) do
      {
        "id" => payment_request.id,
        "status" => payment_request.status
      }.to_json
    end

    subject { described_class.call(payment_request) }

    it "emits updated payment request event" do
      allow(WaterDrop::AsyncProducer).to receive(:call)
      expect(WaterDrop::AsyncProducer).to(
        receive(:call).with(expected_event_message, topic: "payment_request_updated")
      )
        subject
    end
  end
end
