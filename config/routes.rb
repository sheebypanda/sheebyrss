Rails.application.routes.draw do
  devise_for :users
  root 'sources#index'
  resources :sources

end
