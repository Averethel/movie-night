MovieNight::Application.routes.draw do
  get '/signout' => 'sessions#destroy', as: :signout
  get '/signet/google/auth_callback' => 'sessions#create'

  root to: 'home#index'
end
