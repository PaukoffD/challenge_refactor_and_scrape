Rails.application.routes.draw do
  resources :customers do
    resources :devices, shallow: true
  end

  # You can have the root of your site routed with "root"
  root 'customers#index'

end
