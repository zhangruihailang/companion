class UsersController < ApplicationController
  require 'rest-client'
  require 'json' 
  skip_before_filter :verify_authenticity_token, :only => [:create,:send_sms_code]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers, :myProfile]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def new
    @user = User.new
    
  end
  
  
  def myProfile
    @total_income_payed = Order.where("user_id = :user_id and has_payed = '1' ",user_id: current_user.id).sum("income")
    @total_asset = Order.where("user_id = :user_id ",user_id: current_user.id).sum("amount") + 
                   Order.where("user_id = :user_id ",user_id: current_user.id).sum("income")
                   
    @total_asset_available = Order.where("user_id = :user_id and has_payed = '1' ",user_id: current_user.id).sum("amount") + 
                   Order.where("user_id = :user_id and has_payed = '1' ",user_id: current_user.id).sum("income")
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
      if !(params[:user][:smscode].blank?) && !(params[:user][:mobile].blank?) && !(@smscode.nil?) && (@smscode.code == params[:user][:smscode])
        #验证码正确
        @user = User.new(user_params)
        if @user.save
          log_in @user
          flash[:success] = "注册成功!"
          # redirect_to @user
          # UserMailer.account_activation(@user).deliver_now
          # @user.send_activation_email
          # flash[:info] = "Please check your email to activate your account."
          redirect_to root_url
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
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

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
    @smscode =  100000+rand(899999)
    #session[:smscode] 
    #session[:smscode] = @smscode
    @sms = Smscode.find_by(mobile: params[:mobile]) 
    unless @sms
      @sms = Smscode.new
      @sms.mobile = params[:mobile]
    end
    #sms = Smscode.new
    # sms.mobile = params[:mobile]
    # sms.code = @smscode
    # sms.save
    @sms.code = @smscode
    @sms.save
    #Smscode.create!(:mobile =>params[:mobile],:code => @smscode) 
    p "-------------------#{@smscode}--------------------------"
    # respond_to do |format|
    #   #format.html { redirect_to signup_url }
    #   #format.js { render :layout => false }
    #   format.json { render :json => @smscode }
    # end
    render :json => { :smscode => @smscode}
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:mobile, :smscode, :password,
                      :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      #redirect_to root_url unless @user == current_user
      redirect_to root_url unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
