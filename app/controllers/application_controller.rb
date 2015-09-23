class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_url_path
  before_action :get_weixin_openid
  before_action :put_weixin_openid
  include SessionsHelper
  around_filter :rescue_record_not_found   
  #before_action :has_setup_profile
  
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
        #authenticate_openid!
      end
    end
    
    def has_setup_profile
      if logged_in_user && current_user.interests.nil?
      flash[:danger] = "您的资料还不完善，请先更新资料."
      redirect_to "/setup?id=#{@current_user.id}"
      end
    end
    
    def get_url_path
      @url_path = URI(request.url).path
      Rails.logger.info "---------------------------url_path=#{@url_path}--------------------"
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
 
    #获取openid并设置session
    def authenticate_openid!
      @headers = env.select {|k,v| k.start_with? 'HTTP_'}
      .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
      .collect {|pair| pair.join(": ") << "<br>"}
      .sort
      if @headers.to_s.downcase.include?('micromessenger')
        Rails.logger.info "-----------------------微信浏览器访问--------------------------------------------"
        # 当session中没有openid时，则为非登录状态
        if session[:weixin_openid].blank?
          Rails.logger.info "-----------------------session中没有openid--------------------------------------------"
          code = params[:code]
           Rails.logger.info "----------------------------code:#{code}---------------------------------------"
          # 如果code参数为空，则为认证第一步，重定向到微信认证
          if code.nil?
            redirect_to "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Weixin::APP_ID}&redirect_uri=#{request.url}&response_type=code&scope=snsapi_base&state=123"
          end
          
          #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
          begin
            url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{Weixin::APP_ID}&secret=#{Weixin::APP_SECRET}&code=#{code}&grant_type=authorization_code"
            openid = JSON.parse(URI.parse(url).read)["openid"]
            session[:weixin_openid] = openid
            user = User.find_by(weixin_id: openid) 
            if user && !user.mobile.blank?
              Rails.logger.info "--------------------------------当前用户已绑定手机号mobile：#{user.mobile},登陆并设置session-------------------------------"
              log_in user  #登陆并设置session
              @current_user = user
            else
              store_location
              flash[:danger] = "您尚未登陆,请登录后再操作."
              redirect_to(login_url) 
            end
          rescue Exception => e
            # 
            flash[:errors] = "登陆失败"
          end
        end
        # session[:weixin_openid]
        user = User.find_by(weixin_id: session[:weixin_openid]) 
        if user && !user.mobile.blank?
          Rails.logger.info "--------------------------------当前用户已绑定手机号mobile：#{user.mobile},登陆并设置session-------------------------------"
          log_in user  #登陆并设置session
          @current_user = user
        else
          store_location
          flash[:danger] = "您尚未登陆,请登录后再操作."
          redirect_to(login_url) 
        end
        Rails.logger.info "-----------------------session中有openid：#{session[:weixin_openid]}--------------------------------------------"
      else
        store_location
        flash[:danger] = "您尚未登陆,请登录后再操作."
        redirect_to(login_url) 
      end
      #session[:weixin_openid]
    end
    
    def get_weixin_openid
      Rails.logger.info "-------------------------Rails.logger.info-----------------------"
      code = params[:code]
      
      if !code.nil? && !logged_in? 
        Rails.logger.info "------------------从公众号第一次进入,且没有登录信息----------code:#{code}---------------------------------------"
        @headers = env.select {|k,v| k.start_with? 'HTTP_'}
        .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
        .collect {|pair| pair.join(": ") << "<br>"}
        .sort
        if @headers.to_s.downcase.include?('micromessenger')
           Rails.logger.info "-----------------------微信浏览器访问--------------------------------------------"
          #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
          begin
            url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{Weixin::APP_ID}&secret=#{Weixin::APP_SECRET}&code=#{code}&grant_type=authorization_code"
            openid = JSON.parse(URI.parse(url).read)["openid"]
            # session[:weixin_openid] = openid
            user = User.find_by(weixin_id: openid) 
            if user && !user.mobile.blank?
              Rails.logger.info "--------------------------------当前用户已绑定手机号mobile：#{user.mobile},登陆并设置session-------------------------------"
              log_in user  #登陆并设置session
              @current_user = user
            else
              store_location
              flash[:danger] = "您尚未登陆,请登录后再操作."
              redirect_to(login_url) 
            end
          rescue Exception => e
            # 
            flash[:errors] = "登陆失败"
          end
        end
      end      
    end
    
    
    def put_weixin_openid
      code = params[:code]
      
      if !code.nil? && logged_in? 
        Rails.logger.info "------------------从公众号第一次进入,且有登录信息----------code:#{code}---------------------------------------"
        if current_user.weixin_id.nil? || current_user.weixin_id.blank?
          Rails.logger.info "------------------用户没有记录过weixin_id，开始记录----------------------------"
          @headers = env.select {|k,v| k.start_with? 'HTTP_'}
          .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
          .collect {|pair| pair.join(": ") << "<br>"}
          .sort
          if @headers.to_s.downcase.include?('micromessenger')
            Rails.logger.info "-----------------------微信浏览器访问，获取oppenid--------------------------------------------"
            begin
              url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{Weixin::APP_ID}&secret=#{Weixin::APP_SECRET}&code=#{code}&grant_type=authorization_code"
              openid = JSON.parse(URI.parse(url).read)["openid"]
              if !openid.blank?
                current_user.update_attributes(:weixin_id => openid);
                Rails.logger.info "--------------------获取到openid:#{openid}，并设置给current_user:#{current_user.id}-------------------------"
              end
          rescue Exception => e
            # 
            flash[:errors] = "登陆失败"
          end
          end
        end
        
        @headers = env.select {|k,v| k.start_with? 'HTTP_'}
        .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
        .collect {|pair| pair.join(": ") << "<br>"}
        .sort
        if @headers.to_s.downcase.include?('micromessenger')
           Rails.logger.info "-----------------------微信浏览器访问--------------------------------------------"
          #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
          begin
            url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{Weixin::APP_ID}&secret=#{Weixin::APP_SECRET}&code=#{code}&grant_type=authorization_code"
            openid = JSON.parse(URI.parse(url).read)["openid"]
            # session[:weixin_openid] = openid
            user = User.find_by(weixin_id: openid) 
            if user && !user.mobile.blank?
              Rails.logger.info "--------------------------------当前用户已绑定手机号mobile：#{user.mobile},登陆并设置session-------------------------------"
              log_in user  #登陆并设置session
              @current_user = user
            else
              store_location
              flash[:danger] = "您尚未登陆,请登录后再操作."
              redirect_to(login_url) 
            end
          rescue Exception => e
            # 
            flash[:errors] = "登陆失败"
          end
        end
      end      
    end
end
