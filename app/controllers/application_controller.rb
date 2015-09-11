class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_url_path
  include SessionsHelper
  around_filter :rescue_record_not_found   
  before_filter :has_setup_profile
  
  def rescue_record_not_found   
    begin   
      yield   
    rescue ActiveRecord::RecordNotFound   
      render :file => "/public/404.html"  
    end   
  end  
  
 
  
  private
  # 确保用户已登录
    def logged_in_user
      #authenticate_openid!
      unless logged_in?
      store_location
      flash[:danger] = "您尚未登陆,请登录后再操作."
      redirect_to(login_url) and return
      end
    end
    
    def has_setup_profile
      if logged_in_user && current_user.interests
      flash[:danger] = "您的资料还不完善，请先更新资料."
      redirect_to "/setup?id=#{@current_user.id}"
      end
    end
    
    def get_url_path
      @url_path = URI(request.url).path
      p "---------------------------url_path=#{@url_path}--------------------"
    end
    
    def get_home_data
      #authenticate_openid!
      @parent_id = params[:parent_id]
      unless @parent_id
        @parent_id = 1
      end 
      @categories = Category.where(:parent_id => 0)
      @child_categories  = Category.where(:parent_id => @parent_id)
    end
 
end
