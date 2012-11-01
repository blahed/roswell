Roswell::Application.routes.draw do
  get 'signup', :to => 'users#new', :as => 'signup'
  get 'login', :to => 'sessions#new', :as => 'login'
  get 'logout', :to => 'sessions#destroy', :as => 'logout'

  resources :sessions
  resources :users

  resources :accounts
  resources :software_licenses
  get 'software_licenses/tag/:tag', :to => 'software_licenses#tagged', :as => 'tagged_software_licenses'
  resources :notes
  get 'notes/tag/:tag', :to => 'notes#tagged', :as => 'tagged_notes'

  root :to => 'notes#index'
end
