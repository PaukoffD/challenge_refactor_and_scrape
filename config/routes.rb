Rails.application.routes.draw do
  resources :customers

  # You can have the root of your site routed with "root"
  root 'customers#index'

end
