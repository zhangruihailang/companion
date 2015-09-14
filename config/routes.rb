Rails.application.routes.draw do
  
  resources :posts

  resources :categories

  get 'order/new'

  get 'order/create'

  mount WeixinRailsMiddleware::Engine, at: "/"
  resources :projects

  root 'static_pages#playmates'
  get 'playmates' => 'static_pages#playmates'
  get 'topics' => 'static_pages#topics'
  get 'activities' => 'static_pages#activities'
  get 'setup' => 'users#setup'
  get 'publish_message' => 'users#publish_message'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  post 'send_sms_code' => 'users#send_sms_code'
  post 'upload_mirco_pics' => 'users#upload_mirco_pics'
  get 'upload_msg_pic' => 'microposts#upload_msg_pic'
  patch 'upload_pics' => 'microposts#upload_pics'
  get 'loading' => 'weixin_loading#show'
  post 'goto' => 'weixin_loading#goto'
  get 'myFunds' => 'projects#myFunds'
  get 'myProfile' => 'users#myProfile'
  get 'buy' => 'projects#buy'
  
  post 'like' => 'microposts#like'
  post 'unlike' => 'microposts#unlike'
  
  get 'post_comments' => 'microposts#post_comments'
  patch 'post_comment' => 'microposts#post_comment'
  get 'to_post_comment' => 'microposts#to_post_comment'
  
  delete 'logout' => 'sessions#destroy'
  
  get 'delete_comment' => 'microposts#delete_comment'
  
  get 'show_post_likeds' => 'microposts#show_post_likeds'
  
  resources :users , only: [:new, :create, :edit, :update,:myProfile]do
    member do
      get :following, :followers
    end
  end
  
  
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  
  resources :orders, only: [:new,:create, :destroy]
  
  get 'weixin' => 'users#weixin_callback'
  
  get 'smscode' => 'sms_code#send_code'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

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
  
  # '*unmatched_route', :to => 'application#raise_not_found!'  

end
