Rails.application.routes.draw do
  
  get 'business/index'
  get 'business/goto'

  resources :channel_classes

  get 'spider_test' => 'spider#test'
  
  get 'admin/index'

  resources :goods

  resources :good_classes

  resources :topics

  resources :channels

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
  get 'topics_of_category' => 'static_pages#topics_of_category'
  get 'admin' => 'admin#index'
  
  get 'show_channels' => 'static_pages#channels'
  get 'show_channel_classes' => 'static_pages#channel_classes'
  get 'delete_channel' => 'channels#destroy'
  get 'delete_channel_class' => 'channel_classes#destroy'
  get 'show_channels_of_class' => 'channels#show_channels_of_class'
  post 'search_channels' => 'channels#search_channels'
  post 'search_channel_classes' => 'channel_classes#search_channel_classes'
  get 'topics_of_channel' => 'channels#topics_of_channel'
  get 'to_publish_topic_of_channel' => 'channels#to_publish_topic_of_channel'
  get 'to_publish_topic_of_category' => 'categories#to_publish_topic_of_category'
  post 'publish_topic_of_channel' => 'channels#publish_topic_of_channel'
  post 'publish_topic_of_category' => 'categories#publish_topic_of_category'
  get 'to_upload_topic_pic' => 'channels#to_upload_topic_pic'
  get 'to_upload_topic_pic_weixin' => 'channels#to_upload_topic_pic_weixin'
  patch 'upload_topic_pics' => 'channels#upload_topic_pics'
  patch 'upload_topic_pics_weixin' => 'channels#upload_topic_pics_weixin'
  get 'delete_topic' => 'topics#delete_topic'
  post 'topic_like' => 'topics#like'
  post 'topic_unlike' => 'topics#unlike'
  get 'show_topic_likes' => 'topics#show_topic_likes'
  get 'topic_comments' => 'topics#topic_comments'
  get 'to_post_topic_comment' => 'topics#to_post_topic_comment'
  get 'delete_topic_comment' => 'topics#delete_comment'
  patch 'post_topic_comment' => 'topics#post_topic_comment'
  post 'topic_comment_like' => 'topics#comment_like'
  post 'topic_comment_unlike' => 'topics#comment_unlike'
  
  
  get 'to_upload_good_pic' => 'goods#to_upload_good_pic'
  get 'to_upload_good_pic_weixin' => 'goods#to_upload_good_pic_weixin'
  patch 'upload_good_pics' => 'goods#upload_good_pics'
  patch 'upload_good_pics_weixin' => 'goods#upload_good_pics_weixin'
  post 'good_like' => 'goods#like'
  post 'good_unlike' => 'goods#unlike'
  get 'show_good_likes' => 'goods#show_good_likes'
  get 'delete_good' => 'goods#delete_good'
  get 'good_comments' => 'goods#good_comments'
  get 'to_post_good_comment' => 'goods#to_post_good_comment'
  get 'delete_good_comment' => 'goods#delete_comment'
  patch 'post_good_comment' => 'goods#post_good_comment'
  
  
  get 'send_im_mgs' => 'users#send_im_mgs'
  get 'my_conversation_list' => 'users#my_conversation_list'
  
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
  get 'upload_msg_pic_weixin' => 'microposts#upload_msg_pic_weixin'
  #get 'upload_activity_pic' => 'activities#upload_activity_pic'
  
  get 'upload_activity_pic' => 'activities#upload_activity_pic'
  get 'upload_activity_pic_weixin' => 'activities#upload_activity_pic_weixin'
  patch 'upload_msg_pics' => 'microposts#upload_pics'
  patch 'upload_msg_pics_weixin' => 'microposts#upload_pics_weixin'
  post 'upload_activity_pics' => 'activities#upload_pics'
  post 'upload_activity_pics_weixin' => 'activities#upload_pics_weixin'
  post 'upload_user_avatar' => 'users#upload_user_avatar'
  post 'upload_user_avatar_weixin' => 'users#upload_user_avatar_weixin'
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
  get 'to_upload_user_avatar_weixin' => 'users#to_upload_user_avatar_weixin'
  
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
  get 'topics_of_user' => 'users#topics_of_user'
  get 'topics_of_user_replied' => 'users#topics_of_user_replied'
  
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
  
  get 'test_upload' => 'static_pages#test_upload'
  
  post 'download_pic_from_weixin' => 'static_pages#download_pic_from_weixin'

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
