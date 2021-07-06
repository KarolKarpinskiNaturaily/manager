# frozen_string_literal: true

class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.all
  end

  def edit
    @payment_request = PaymentRequest.find(params[:id])
  end

  def update
    payment_request = PaymentRequest.update!(payment_request_params)
    emit_updated_payment_request_event(payment_request)
    redirect_to root_path, notice: "Payment request has been updated"
    rescue ActiveRecord::ActiveRecordError => e
      flash[:alert] = e.message
      @payment_request = PaymentRequest.find(params[:id])
      render :edit
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:status)
  end

  def emit_updated_payment_request_event(payment_request)
    WaterDrop::SyncProducer.call(
      {
        id: payment_request.id,
        status: payment_request.status
      },
      topic: "payment_request_updated")
  end
end
