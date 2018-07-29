# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  get "/" => "home#index"
  get "/ping", to:"application#ping"
  get "/profile" => "profile#show"
  get "/logout" => "logout#logout"
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  resources :animals, except: [:show]
end
