Rails.application.routes.draw do
  
  resources :activities, only: [:new, :create, :edit, :update, :destroy]
  get 'delete_activity' => 'activities#delete_activity' 
  get 'delete_micropost' => 'microposts#delete_micropost'

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
  get 'publish_activity' => 'activities#new'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  post 'send_sms_code' => 'users#send_sms_code'
  post 'upload_mirco_pics' => 'users#upload_mirco_pics'
  get 'upload_msg_pic' => 'microposts#upload_msg_pic'
  #get 'upload_activity_pic' => 'activities#upload_activity_pic'
  
  get 'upload_activity_pic' => 'activities#upload_activity_pic'
  patch 'upload_msg_pics' => 'microposts#upload_pics'
  post 'upload_activity_pics' => 'activities#upload_pics'
  post 'upload_user_avatar' => 'users#upload_user_avatar'
  get 'loading' => 'weixin_loading#show'
  post 'goto' => 'weixin_loading#goto'
  get 'myFunds' => 'projects#myFunds'
  get 'myProfile' => 'users#myProfile'
  get 'hisProfile' => 'users#hisProfile'
  get 'herProfile' => 'users#herProfile'
  get 'buy' => 'projects#buy'
  
  post 'like' => 'microposts#like'
  post 'unlike' => 'microposts#unlike'
  
  get 'post_comments' => 'microposts#post_comments'
  get 'activity_comments' => 'activities#activity_comments'
  patch 'post_comment' => 'microposts#post_comment'
  patch 'post_activity_comment' => 'activities#post_activity_comment'
  post 'leave_message' => 'users#leave_message'
  get 'leave_messages' => 'users#leave_messages'
  get 'to_post_comment' => 'microposts#to_post_comment'
  get 'to_activity_comment' => 'activities#to_activity_comment'
  get 'to_leave_message' => 'users#to_leave_message'
  delete 'logout' => 'sessions#destroy'
  
  get 'delete_comment' => 'microposts#delete_comment'
  get 'delete_activity_comment' => 'activities#delete_activity_comment'
  get 'delete_user_message' => 'users#delete_message'
  get 'show_post_likeds' => 'microposts#show_post_likeds'
  get 'show_activity_applies' => 'activities#show_activity_applies'
  get 'apply_activity' => 'activities#apply_activity'
  get 'cancel_activity_apply' => 'activities#cancel_activity_apply'
  
  get 'to_upload_user_avatar' => 'users#to_upload_user_avatar'
  
  resources :users , only: [:new, :create, :edit, :update,:myProfile]do
    # member do
    #   get :following, :followers
    # end
  end
  
  get 'show_photos' => 'users#show_photos'
  get 'update_user' => 'users#update_user'
  
  get 'posts_of_user' => 'users#posts_of_user'
  get 'activities_of_user' => 'users#activities_of_user'
  get 'activities_of_user_applied' => 'users#activities_of_user_applied'
  
  get 'privacy' => 'static_pages#privacy'
  get 'about_us' => 'static_pages#about_us'
  get 'agreement' => 'static_pages#agreement'
  
  get 'followings' => 'users#followings'
  get 'followers' => 'users#followers'
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
