# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"
  get "/" => "home#index"

  resources :animals
  resources :species

  get "profile" => "profile#show"
  get "logout" => "logout#logout"
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

end
