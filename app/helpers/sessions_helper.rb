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
    if (user_id = session[:user_id]) #有session
      p "--------------------------------有session:#{user_id}-------------------------------"
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])#无session，有cokkie
      p "--------------------------------无session，有cokkien:#{user_id}-------------------------------"
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])#验证cokkie
        p "--------------------------------验证cokkie通过，登陆并设置session------------------------------"
        log_in user  #登陆并设置session
        @current_user = user
      end
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
