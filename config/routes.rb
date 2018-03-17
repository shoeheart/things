Rails.application.routes.draw do
  get '/' => 'welcome#index'
  resources :animals

  # from https://blog.codeship.com/unobtrusive-javascript-via-ajax-rails/
  #scope :ujs, default: { format: :ujs } do
    patch 'animals_totals' => 'animals#totals'
  #end
end
