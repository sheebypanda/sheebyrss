Rails.application.routes.draw do

  devise_for :users
  root 'welcome#home'

  resources :sources

end
