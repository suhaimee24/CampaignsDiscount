Rails.application.routes.draw do
  resources :campaigns, only: [:create]
end
