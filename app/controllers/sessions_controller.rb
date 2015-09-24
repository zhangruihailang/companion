class SessionsController < ApplicationController
  require 'download'
  
  def new
  end
  
  # def create
  #   user = User.find_by(email:params[:session][:email].downcase)
  #   if user && user.authenticate(params[:session][:password])
  #     #登陆用户
  #     log_in user
  #     #remember user
  #     params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  #     redirect_to user
  #   else
  #     flash.now[:danger] = "Invalid email/password combination!"
  #     render 'new'
  #   end
  # end
  # def create
  #   @user = User.find_by(email:params[:session][:email].downcase)
  #   if @user && @user.authenticate(params[:session][:password])
  #     #登陆用户
  #     log_in @user
  #     #remember user
  #     params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  #     #redirect_to @user
  #     #如果用户登录前访问过未授权的页面，此时跳转到该页面中，否则跳到用户资料页
  #     redirect_back_or @user
  #   else
  #     flash.now[:danger] = "Invalid email/password combination!"
  #     render 'new'
  #   end
  # end
  
  def create
    
    @user = User.find_by(mobile:params[:session][:mobile])
    if @user && @user.authenticate(params[:session][:password])
      # if  @user.activated?  #激活用户才能登陆
      #   #登陆用户
      #   log_in @user
      #   #remember user
      #   params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      #   #redirect_to @user
      #   #如果用户登录前访问过未授权的页面，此时跳转到该页面中，否则跳到用户资料页
      #   redirect_back_or @user
      # else
      #   message = "Account not activated. "
      #   message += "Check your email for the activation link."
      #   flash[:warning] = message
      #   redirect_to root_url
      # end
      #登陆用户
      log_in @user
      remember @user
      redirect_back_or root_url
    else
      flash.now[:danger] = "手机号或密码不正确!"
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  def download_pic_from_weixin
    midia_id = params[:midia_id]
    access_token = get_access_token
    uri_path = "http://file.api.weixin.qq.com"
    target_local_file_path = "/cgi-bin/media/get?access_token=#{access_token}&media_id=#{midia_id}"
    p "---------------------------midia_id:#{midia_id}-----------------------------------"
    p "---------------------------access_token:#{access_token}-----------------------------------"
    p "---------------------------uri_path:#{uri_path}-----------------------------------"
    p "---------------------------target_local_file_path:#{target_local_file_path}-----------------------------------"
    file = Download.file(uri_path,target_local_file_path)
    render :json => { :smscode => "#{file.path}"}
  end
  
end
