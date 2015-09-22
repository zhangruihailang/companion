class UsersController < ApplicationController
  require 'rest-client'
  require 'json' 
  skip_before_filter :verify_authenticity_token, :only => [:create,:send_sms_code,:upload_mirco_pics]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers, :myProfile, :upload_mirco_pics, :publish_message]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  
  
  
  
  def new
    @user = User.new
    
  end
  
  def publish_message
    @micropost = Micropost.new
  end
  
  def upload_mirco_pics
    @micropost = Micropost.new
    @micropost.user_id = current_user.id
    @pic_urls = ''
    response.headers['Access-Control-Allow-Origin'] = '*' 
    if @micropost.save
      if params[:files] && params[:files].any? 
        params[:files].each do |file|
        @attachment = @micropost.message_pic.create!(:file => file)
        @pic_urls += ",#{@attachment.file.url('400')}"
        end
      end
      p '---------------------------上传成功-----------------------------'
      #render text: "上传成功"#@pic_urls.to_s
      flash[:notice] = "上传成功"
      #redirect_to "/"
      render js: "window.location = '/'"
    else
      # render :json => { :smscode => '上传失败，请重新上传'}
      #render text: "上传失败，请重新上传"
      flash[:notice] = "上传失败"
      redirect_to "/"
    end
    
  end 
         
  
  def myProfile
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  def hisProfile
     @user = User.find(params[:id])
  end
  
  def herProfile
     @user = User.find(params[:id])
  end
  
  def show_photos
    @user = User.find(params[:user_id])
    if !@user.avatars.url.blank?
      @avatars = @user.avatars
    end
    @post_pics = []
    @user.microposts.each do |post|
      post.message_pics.each do |pic|
        @post_pics.push(pic)
      end
    end
    @activitie_pics = []
    @user.activities.each do |activity|
      activity.activity_pics.each do |pic|
        @activitie_pics.push(pic)
      end
    end
  end
  
  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
    #flash.now[:tag] = "count:#{@users.count}"
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
   # debugger
  end
  
  def create
    #验证短信码
    
    @smscode = Smscode.find_by(mobile: params[:user][:mobile]) 
    #p "------------------------------session[:smscode]:#{@smscode.code}---------------------------------------"
    p "----------------------------  params[:user][:smscode]:#{params[:user][:smscode]}---------------------------------------"
    #注册过的用户不能再注册
    
    @user = User.find_by(mobile: params[:user][:mobile]) 
    if @user
      flash[:success] = "该手机号已经注册过!"
      render 'new'
    else
      
      # url = "http://www.charmdate.cn:9090/Charm/mobileUserManageNRAction.do?command=compareSmsCodeCallBackMess&mobile=#{params[:user][:mobile]}&smscode=#{params[:user][:smscode]}"
      # flag = JSON.parse(URI.parse(url).read)["status"]

      if !(params[:user][:smscode].blank?) && !(params[:user][:mobile].blank?) && !(@smscode.nil?) && (@smscode.code == params[:user][:smscode])
      #if !(params[:user][:smscode].blank?) && !(params[:user][:mobile].blank?) && !(flag.nil?) && flag == '1' 
        #验证码正确
        @user = User.new(user_params)
        if @user.save
          log_in @user
          flash[:success] = "注册成功!"
          # redirect_to @user
          # UserMailer.account_activation(@user).deliver_now
          # @user.send_activation_email
          # flash[:info] = "Please check your email to activate your account."
          redirect_to "/setup?id=#{@user.id}"
        else
          #@user = User.new
          #p "---------------------@user#{@user}--------------------------------------"
          #p "---------------------@user#{@user.errors.full_messages.each{|msg| p msg} }--------------------------------------"
          render 'new'
              
           #render text: "errors"
        end
      else
         #验证码不正确
         @user = User.new
          p "---------------------@user#{@user}--------------------------------------"
        flash[:info] = "验证码不正确"
        render 'new'
      end
    end
    
    
  end
  
  def posts_of_user
    #@microposts = User.find(params[:id]).microposts
    @user =  User.find(params[:id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@user.microposts.count(:id).to_i - 1)/page_size )+1

    @microposts = @user.microposts.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def followings
    @user =  User.find(params[:id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@user.active_relationships.count(:id).to_i - 1)/page_size )+1

    @followings = @user.active_relationships.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def followers
    @user =  User.find(params[:id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@user.passive_relationships.count(:id).to_i - 1)/page_size )+1

    @followers = @user.passive_relationships.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def activities_of_user
    #@activities = User.find(params[:id]).activities
    @user =  User.find(params[:id])
     @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@user.activities.count(:id).to_i - 1)/page_size )+1

    @activities = @user.activities.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end
  
  def activities_of_user_applied
    @activities = []
    @user =  User.find(params[:id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((ActivityApply.where(:apply_user_id => params[:id]).count(:id).to_i - 1)/page_size )+1

    @applies = ActivityApply.where(:apply_user_id => params[:id]).order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    @applies.each do |apply|
      @activities.push(apply.activity)
    end
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
    
    
  end
  
  def topics_of_user_replied
    @topics = []
    @user =  User.find(params[:id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@user.topic_comments.count(:id).to_i - 1)/page_size )+1

    @comments = @user.topic_comments.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    # p "---------------------------comment.count--------------#{ @comments.count}------------"
    
    @comments.each do |comment|
      @topics.push(comment.topic) if (!comment.topic.nil? && !@topics.include?(comment.topic))
      # p "---------------------------comment.topic--------------#{comment.topic.title}------------"
    end
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  
  def topics_of_user
     @user =  User.find(params[:id])
     @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@user.topics.count(:id).to_i - 1)/page_size )+1

    @topics = @user.topics.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def setup
    @user = current_user || User.find(params[:id])
  end
  
  def update_user
    @user = current_user || User.find(params[:id])
  end
  
  def to_upload_user_avatar
     @user = current_user || User.find(params[:id])
  end
  
  def upload_user_avatar
     @user = current_user || User.find(params[:user_id])
     if params[:files] && params[:files].any? 
        params[:files].each do |file|
        #@attachment = @micropost.message_pic.create!(:file => file)
        @user.update_attributes(:avatars => file)
        end
     end
     
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     render 'to_upload_user_avatar'
  end
  
  
  def to_leave_message
    @is_reply = params[:reply]
    @to_user = User.find(params[:id])
    @to_reply_user = User.find(params[:to_reply_user_id])
  end
  
  def leave_message
    @to_user = User.find(params[:user_id])
    @to_user.user_comments.create(:post_user_id => current_user.id,:content => params[:content])
    redirect_to "/leave_messages?id=#{@to_user.id}"
  end
  
  def leave_messages
    @to_user = User.find(params[:id])
    
    #@likeds = @micropost.likeds
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@to_user.user_comments.count(:id).to_i - 1)/page_size )+1
    @user_comments = @to_user.user_comments.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def delete_message
    comment = UserComment.find(params[:id])
    comment.destroy
    redirect_to "/leave_messages?id=#{comment.user.id}"
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      if params[:if_completed] == 'yes'
        flash[:success] = "资料更新成功！"
        redirect_to '/'
      else
        redirect_to "/to_upload_user_avatar?id=#{@user.id}"
      end
    else
      redirect_to "/setup?id=#{@user.id}"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  # def following
  #   @title = "Following"
  #   @user = User.find(params[:id])
  #   @users = @user.following.paginate(page: params[:page])
  #   render 'show_follow'
  # end
  # def followers
  #   @title = "Followers"
  #   @user = User.find(params[:id])
  #   @users = @user.followers.paginate(page: params[:page])
  #   render 'show_follow'
  # end

  # def weixin_callback
    
  #   headers = env.select {|k,v| k.start_with? 'HTTP_'}
  #   .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
  #   .collect {|pair| pair.join(": ") << "<br>"}
  #   .sort
  #   #[200, {'Content-Type' => 'text/html'}, headers]
    
  #   p "----------------------headers:#{headers.to_s.downcase.include?('micromessenger')}------------------------------------------------------------------"
  #   p "----------------------params[:redirect_uri]:#{params[:redirect_uri]}--------------------------------"
  #   p "----------------------params[:code]:#{params[:code]}--------------------------------"
  #   code = params[:code]
  #   access_token_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxad6c3ea93ded84fd&secret=a92a8e30e2caceec8c9d7d103197f2f5&code=#{code}&grant_type=authorization_code"
  #   p "----------------------url:#{access_token_url}--------------------------------"
  #   response = RestClient.get access_token_url
  #   p "--------------------------------------------------------------------------------------"
  #   p response.to_str
  #   p "--------------------------------------------------------------------------------------"
  #   result=JSON.parse(response.to_str)  
  #   #p result  
  #   p   "------------------------------result['access_token']:#{result['access_token']}--------------------------------------------------------" 
  #   access_token = result['access_token']
  #   openid = result['openid']
  #   # userinfo_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
  #   # response = RestClient.get access_token_url
  #   # p "--------------------------------------------------------------------------------------"
  #   # p response.to_str
  #   # p "--------------------------------------------------------------------------------------"
  #   # result=JSON.parse(response.to_str)  
  #   # p   "------------------------------result['nickname']:#{result['nickname']}-----------------------------------" 
  #   # p   "------------------------------result['headimgurl']:#{result['headimgurl']}-----------------------------------" 

  #   render text: "weixin callback success"
  # end
  
  def send_sms_code
    # @smscode =  100000+rand(899999)
    # #session[:smscode] 
    # #session[:smscode] = @smscode
    # @sms = Smscode.find_by(mobile: params[:mobile]) 
    # unless @sms
    #   @sms = Smscode.new
    #   @sms.mobile = params[:mobile]
    # end
    # #sms = Smscode.new
    # # sms.mobile = params[:mobile]
    # # sms.code = @smscode
    # # sms.save
    # @sms.code = @smscode
    # @sms.save
    # #Smscode.create!(:mobile =>params[:mobile],:code => @smscode) 
    # p "-------------------#{@smscode}--------------------------"
    # # respond_to do |format|
    # #   #format.html { redirect_to signup_url }
    # #   #format.js { render :layout => false }
    # #   format.json { render :json => @smscode }
    # # end
    # render :json => { :smscode => @smscode}
    
    
    
    # url = "http://www.charmdate.cn:9090/Charm/mobileUserManageNRAction.do?command=sendSmsCodeCallBackMess&mobile=#{params[:mobile]}"
    # message = JSON.parse(URI.parse(url).read)["message"]
    # render :json => { :smscode => message}
    
    @smscode =  100000+rand(899999)
    @sms = Smscode.find_by(mobile: params[:mobile]) 
    unless @sms
      @sms = Smscode.new
      @sms.mobile = params[:mobile]
    end
    @sms.code = @smscode
    @sms.save
    p "----------------smscode======#{@smscode}--------------------------"
    Rails.logger.info("----------------smscode======#{@smscode}--------------------------")
    
    
    account_sid =  "439c50e3ccf174139c13def5a00be034"
    restURL = "https://api.ucpaas.com"
    version = "2014-06-30"
    auth_token = "49ee5da5489b144012728f719ae506a7"
    appid = "2f49e5e9e627402aaa5c86422d116da4"
    templateId = "13119"
    
    sig = Digest::MD5.hexdigest(("#{account_sid}"+"#{auth_token}"+DateTime.parse(Time.now.to_s).strftime('%Y%m%d%H%M%S').to_s)).upcase
    
    # url = URI.parse("https://api.ucpaas.com/2014-06-30/Accounts/439c50e3ccf174139c13def5a00be034/Messages/templateSMS.xml?sig=#{sig}")
    # path = "/2014-06-30/Accounts/439c50e3ccf174139c13def5a00be034/Messages/templateSMS.xml?sig=#{sig}"
    
    url = URI.parse("#{restURL}/#{version}/Accounts/#{account_sid}/Messages/templateSMS?sig=#{sig}")
    path = "/#{version}/Accounts/#{account_sid}/Messages/templateSMS?sig=#{sig}"
    https = Net::HTTP.new(url.host,url.port)
    https.use_ssl = true    
    authorization = Base64.strict_encode64("#{account_sid}"+":"+DateTime.parse(Time.now.to_s).strftime('%Y%m%d%H%M%S').to_s)
    req = Net::HTTP::Post.new(path,{'Content-Type' => 'application/json;charset=utf-8','Accept' => 'application/json','Authorization' => "#{authorization}"})
    #data =	"<?xml version='1.0' encoding='utf-8'?><templateSMS><appId>ae84fc15535a411093ff63b830969509</appId><templateId>4892</templateId><to>#{params[:mobile]}</to><param>#{@smscode}</param></templateSMS>"
    data = "{\"templateSMS\" : {\"appId\": \"#{appid}\",\"param\": \"#{@smscode}\",\"templateId\": \"#{templateId}\",\"to\": \"#{params[:mobile]}\"}}"

    req.body = data
    res = https.request(req)
    p "------------------------receive----#{res.body}-----------------------------------------------"
    Rails.logger.info("------------------------receive----#{res.body}-----------------------------------------------")
    respCode = JSON.parse(res.body)["resp"]["respCode"]
    p "------------------------respCode----#{respCode}-----------------------------------------------"
    Rails.logger.info("------------------------respCode----#{respCode}-----------------------------------------------")
    if respCode && respCode == '000000'
      render :json => { :smscode => "短信验证码发送成功，请注意查收"}
    else
      render :json => { :smscode => "短信验证码发送失败，你重新发送"}
    end
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:mobile, :smscode, :password, :name, :grade,
                      :password_confirmation, :rolename,
                      :guardian_age, :province, :city, :district,
                      :sex, :age, :school, :interests       )
    end
    
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end
    
    def correct_user
      @user = User.find(params[:id])
      #redirect_to root_url unless @user == current_user
      redirect_to root_url unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
