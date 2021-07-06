# frozen_string_literal: true

class PaymentRequest < ApplicationRecord
  validates :status, inclusion: { in: %w(pending accepted rejected) }
end
