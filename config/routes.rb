# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  get "/" => "home#index"
  get "/dashboard" => "dashboard#index"
  get "/dashboard/counts" => "dashboard#counts"
  resources :animals, except: [:show]

  # uptime health monitoring
  get "/ping" => "application#ping"
end
