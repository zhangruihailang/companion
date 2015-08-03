class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  private
  # 确保用户已登录
    def logged_in_user
      unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
      end
    end
  
  #获取openid并设置session
    def authenticate_openid!

      # 当session中没有openid时，则为非登录状态
      if session[:weixin_openid].blank?
        code = params[:code]
  
        # 如果code参数为空，则为认证第一步，重定向到微信认证
        if code.nil?
          redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Weixin::APP_ID}&redirect_uri=#{request.url}&response_type=code&scope=snsapi_base&state=wexin"
        end
        
        #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
        begin
          url    = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{Weixin::APP_ID}&secret=#{Weixin::APP_SECRET}&code=#{code}&grant_type=authorization_code"
          @openid = JSON.parse(URI.parse(url).read)["openid"]
          #判断当前用户是否绑定手机号
        rescue Exception => e
          # ... 
        end
        user = User.find_by(weixin_id : @openid) 
        if user && !user.mobile.blank?
            session[:weixin_openid] = openid
        end
      end
  
      session[:weixin_openid]
    end
end
