# frozen_string_literal: true

class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.all.order(:id)
  end

  def update
    payment_request.update!(update_payment_request_params)
    EmitUpdatedPaymentRequestEvent.call(payment_request)
    redirect_to root_path, notice: "Payment request has been updated"
    rescue ActiveRecord::ActiveRecordError => e
      flash[:alert] = e.message
      render :index
  end

  private

  def payment_request
    @payment_request ||= PaymentRequest.find(params[:id])
  end

  def update_payment_request_params
    params.permit(:status)
  end
end
