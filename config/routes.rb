# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  get "/" => "welcome#index"
  resources :animals
  resources :species

  # from https://blog.codeship.com/unobtrusive-javascript-via-ajax-rails/
  patch "animals_totals" => "animals#totals"

  get "profile" => "profile#show"
  get "logout" => "logout#logout"
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  root "welcome#index"
end
