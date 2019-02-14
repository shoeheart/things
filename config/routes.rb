# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  get "/" => "home#index"
  get "/dashboard" => "dashboard#index"
  get "/dashboard/counts" => "dashboard#counts"
  resources :animals, except: [:show]

  post Rails.application.credentials.dig(:postmark, :webhook_url) =>
    "postmark_webhook#create"
  post Rails.application.credentials.dig(:postmark, :inbound_url) =>
    "postmark_inbound#create"

  # uptime health monitoring
  get "/ping" => "application#ping"
end
