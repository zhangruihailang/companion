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
  
  def get_headers
       p "===================session_helper code:#{params[:code]}======================"
      @headers = env.select {|k,v| k.start_with? 'HTTP_'}
      .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
      .collect {|pair| pair.join(": ") << "<br>"}
      .sort
    end
  
  
  
  def weixin_login
    p "--------------------------------333333333333333333333-------------------------------"
    get_headers
      if @headers.to_s.downcase.include?('micromessenger') #微信浏览器
          p "--------------------------------微信浏览器访问------------------------------"
          code = params[:code]
          if code && !code.empty?
            p "--------------------------------微信浏览器访问获取到code:#{code}------------------------------"
            access_token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxad6c3ea93ded84fd&secret=a92a8e30e2caceec8c9d7d103197f2f5&code=#{code}&grant_type=authorization_code"
            p "----------------------url:#{access_token_url}--------------------------------"
            response = RestClient.get access_token_url
            p "--------------------------------------------------------------------------------------"
            p response.to_str
            p "--------------------------------------------------------------------------------------"
            result=JSON.parse(response.to_str)  
            #p result  
            p   "------------------------------result['access_token']:#{result['access_token']}--------------------------------------------------------" 
            access_token = result['access_token']
            openid = result['openid']
            if openid && !openid.empty?
              #微信访问而来，没有设置过session和cokkie，使用将微信中的用户登陆并设置session和cokkie
              p   "----------------------微信访问而来，有openid:#{openid},设置session和cokkie---------------------------------------" 
              if (user = User.find_by(weixin_id:openid)) 
                p "---------------------openid:#{openid}已经注册过，登陆并设置session和cokkie----------------------------------"
                if user.mobile && !user.mobile.empty?
                   p "---------------------绑定过手机------------------------------"
                   log_in user
                   #remember user
                   remember(user)
                   @current_user = user
                else
                  p "---------------------未绑定过手机------------------------------"
                  @weixin_id = openid
                end
              else
                p "---------------------openid:#{openid}尚未注册过，注册，登陆并设置session和cokkie----------------------------------"
                User.create(:weixin_id => openid,:password => "foobar", :password_confirmation => "foobar")
                @weixin_id = openid
              end
            end
        end
      end
    end
    
    
  #返回当前登陆用户
  def current_user
    #User.find_by(id: session[:user_id])
    #current_user ||= User.find_by(id:session[:user_id])
    p "--------------------------------11111111111111111-------------------------------"
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
      else
        weixin_login
      end
    elsif get_headers.to_s.downcase.include?('micromessenger') #微信浏览器
          p "--------------------------------微信浏览器访问------------------------------"
          code = params[:code]
          if code && !code.empty?
            p "--------------------------------微信浏览器访问获取到code:#{code}------------------------------"
            access_token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxad6c3ea93ded84fd&secret=a92a8e30e2caceec8c9d7d103197f2f5&code=#{code}&grant_type=authorization_code"
            p "----------------------url:#{access_token_url}--------------------------------"
            response = RestClient.get access_token_url
            p "--------------------------------------------------------------------------------------"
            p response.to_str
            p "--------------------------------------------------------------------------------------"
            result=JSON.parse(response.to_str)  
            #p result  
            p   "------------------------------result['access_token']:#{result['access_token']}--------------------------------------------------------" 
            access_token = result['access_token']
            openid = result['openid']
            if openid && !openid.empty?
              #微信访问而来，没有设置过session和cokkie，使用将微信中的用户登陆并设置session和cokkie
              p   "----------------------微信访问而来，有openid:#{openid},设置session和cokkie---------------------------------------" 
              if (user = User.find_by(weixin_id:openid)) 
                p "---------------------openid:#{openid}已经注册过，登陆并设置session和cokkie----------------------------------"
                if user.mobile && !user.mobile.empty?
                   p "---------------------绑定过手机------------------------------"
                   log_in user
                   #remember user
                   remember(user)
                   @current_user = user
                else
                  puts "---------------------未绑定过手机------------------------------"
                  @weixin_id = openid
                end
              else
                p "---------------------openid:#{openid}尚未注册过，注册，登陆并设置session和cokkie----------------------------------"
                User.create(:weixin_id => openid,:password => "foobar", :password_confirmation => "foobar")
                @weixin_id = openid
              end
            end
        end
      end
  end
  
  
  
  
  #返回当前登陆用户
  def current_user?(user)
      user == current_user
  end
  
  #判断用户是否已登陆
  def logged_in?
    p "current_user=====#{current_user}======================"
    !current_user.nil? && current_user.class == User.class
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
