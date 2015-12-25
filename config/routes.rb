Rails.application.routes.draw do
  resources :check_deliveries, only: [:new, :create]
  get "/check_delivery" => 'check_deliveries#new'
  get "/check_deliveries" => 'check_deliveries#new'
  resources :delivery_companies
  resources :customers do
    resources :devices, shallow: true do
      collection do
        get 'new_import'
        post 'import'
      end
    end
  end

  # You can have the root of your site routed with "root"
  root 'customers#index'

end
