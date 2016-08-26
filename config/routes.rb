Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

   root 'pages#welcome'
   resources :images do
    member do
      get 'toggle_tag'
      post 'add_tag'
      post 'toggle_match'
    end
   end

  resources :users, :except=>[:destroy]

  resource :user_sessions
  get 'login' => 'user_sessions#new'
  get 'logout' => 'user_sessions#destroy'

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
