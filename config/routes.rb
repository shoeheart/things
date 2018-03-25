Rails.application.routes.draw do
  get '/' => 'welcome#index'
  resources :animals
  resources :species

  # from https://blog.codeship.com/unobtrusive-javascript-via-ajax-rails/
  #scope :ujs, default: { format: :ujs } do
    patch 'animals_totals' => 'animals#totals'
  #end

  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
end
