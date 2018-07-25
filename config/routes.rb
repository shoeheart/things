# frozen_string_literal: true

Rails.application.routes.draw do
  resources :minerals
  root "home#index"
  get "/" => "home#index"

  get "/animals/react" => "animals#react_index"
  get "/animals/react_new" => "animals#react_new"
  get "/animals/:id/react_edit" => "animals#react_edit"
  post "/animals/react_create" => "animals#react_create"
  post "/animals/react_create_json" => "animals#react_create_json"
  patch "/animals/:id/react_update_json" => "animals#react_update_json"
  resources :animals, except: [:edit, :new]
  resources :species
  delete "/animals/:id/delete_toy/:toy_id(.:format)" => "animals#delete_toy", as: :animal_delete_toy
  post "/animals/:id/add_toy(.:format)" => "animals#add_toy", as: :animal_add_toy

  get "profile" => "profile#show"
  get "logout" => "logout#logout"
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

end
