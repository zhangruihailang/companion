module SessionsHelper
  #登入指定的用户
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #持久化用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  
    
  #返回当前登陆用户
  def current_user
    #User.find_by(id: session[:user_id])
    #current_user ||= User.find_by(id:session[:user_id])
    #authenticate_openid!
    if (user_id = session[:user_id]) #有session
      Rails.logger.info "--------------------------------has session:#{user_id}-------------------------------"
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])#无session，有cokkie
      Rails.logger.info "-------------------------------- not session，has cokkie:#{user_id}-------------------------------"
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])#验证cokkie
        Rails.logger.info "--------------------------------cokkie got authenticated ，login and set session------------------------------"
        log_in user  #登陆并设置session
        remember(user)
        @current_user = user
      end
    # elsif (openid = session[:weixin_openid]) #有微信用户信息
    #   Rails.logger.info "--------------------------------无session有微信openid:#{openid}-------------------------------"
    #   #判断当前用户是否绑定手机号
      
    #   user = User.find_by(weixin_id:openid) 
    #   if user && !user.mobile.blank?
    #     Rails.logger.info "--------------------------------当前用户已绑定手机号mobile：#{user.mobile},登陆并设置session-------------------------------"
    #     log_in user  #登陆并设置session
    #     @current_user = user
    #   end
    end
  end
  
  
  
  
  #返回当前登陆用户
  def current_user?(user)
      user == current_user
  end
  
  #判断用户是否已登陆
  def logged_in?
    !current_user.nil? 
  end
  
  #忘记持久会话
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
   #用户退出
  def log_out
     forget(current_user)
     session.delete(:user_id)
     @current_user = nil
  end
  
  # 跳转到存储地址或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  # 存储地址
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  
end
