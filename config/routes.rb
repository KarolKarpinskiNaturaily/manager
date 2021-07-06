Rails.application.routes.draw do
  resources :payment_requests, only: %i(index update)

  root "payment_requests#index"
end
