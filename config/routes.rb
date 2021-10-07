Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  # Provides REST-ful routes, which are mapped to Rails actions
  resources :articles
end
