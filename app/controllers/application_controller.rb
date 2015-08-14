class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
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
  
 
end
