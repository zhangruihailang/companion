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
  
  #获取openid并设置session
    def authenticate_openid!
      @headers = env.select {|k,v| k.start_with? 'HTTP_'}
       .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
       .collect {|pair| pair.join(": ") << "<br>"}
       .sort
      if @headers.to_s.downcase.include?('micromessenger')
        p "-----------------------微信浏览器访问--------------------------------------------"
        # 当session中没有openid时，则为非登录状态
        if session[:weixin_openid].blank?
          p "-----------------------session中没有openid--------------------------------------------"
          code = params[:code]
           p "----------------------------code:#{code}---------------------------------------"
          # 如果code参数为空，则为认证第一步，重定向到微信认证
          if code.nil?
            redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Weixin::APP_ID}&redirect_uri=#{request.url}&response_type=code&scope=snsapi_base&state=123"
          end
          
          #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
          begin
            url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{Weixin::APP_ID}&secret=#{Weixin::APP_SECRET}&code=#{code}&grant_type=authorization_code"
            openid = JSON.parse(URI.parse(url).read)["openid"]
            session[:weixin_openid] = openid
          rescue Exception => e
            # 
            flash[:errors] = "登陆失败"
          end
        end
        session[:weixin_openid]
        p "-----------------------session中有openid：#{session[:weixin_openid]}--------------------------------------------"
      end
      #session[:weixin_openid]
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
    elsif (openid = session[:weixin_openid]) #有微信用户信息
      p "--------------------------------无session有微信openid:#{openid}-------------------------------"
      #判断当前用户是否绑定手机号
      
      user = User.find_by(weixin_id:openid) 
      if user && !user.mobile.blank?
        p "--------------------------------当前用户已绑定手机号mobile：#{user.mobile},登陆并设置session-------------------------------"
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
