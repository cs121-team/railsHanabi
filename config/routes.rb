Rails.application.routes.draw do
  root 'games#new'
  get 'games/new'
  get 'games/play'
  devise_for :users
  mount ActionCable.server => "/cable"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end