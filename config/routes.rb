Rails.application.routes.draw do
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
