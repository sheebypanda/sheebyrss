Rails.application.routes.draw do
  devise_for :users
  root 'sources#index'
  get '/update', to: 'sources#update'
  resources :sources

end
