# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentRequestsController do
  let!(:payment_request) { create :payment_request, status: "pending" }

  describe "GET #index" do
    subject { get :index }

    it "returns http success" do
      expect(subject).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    subject { put :update, params: payment_request_params }

    let(:valid_payment_request_params) do
      { id: payment_request.id, payment_request: { status: "accepted" } }
    end
    let(:invalid_payment_request_params) do
      { id: payment_request.id, payment_request: { status: "yes" } }
    end

    context "with valid params" do
      let(:payment_request_params ) { valid_payment_request_params }

      it "updates payment request" do
        expect { subject }.to change { payment_request.reload.status }.to("accepted")
      end

      it "calls service for emitting events" do
        expect(EmitUpdatedPaymentRequestEvent).to(receive(:call).once)
        subject
      end
    end

    context "with ininvalid params" do
      let(:payment_request_params ) { invalid_payment_request_params }

      it "does not update payment request" do
        expect { subject }.not_to change { payment_request.reload.status }
      end
    end
  end
end
