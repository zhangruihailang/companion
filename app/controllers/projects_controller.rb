class ProjectsController < ApplicationController
  require 'rest-client'
  require 'json' 
  
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  #before_action :get_headers
  #before_action :weixin_login
  before_action :logged_in_user
  
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    # files = params[:files]
    # files.each do |file|
    #   #p "------------------------------------------------------------------------------------------"
    #   attachment = Attachment.new
    #   attachment.project_id = @project.id
    #   attachment.file = file
    #   attachment.save
    # end
    respond_to do |format|
      if @project.save
        
        params[:files].each do |file|
          @attachment = @project.attachments.create!(:file => file)
        end
        
        format.html { redirect_to @project, notice: '项目发布成功.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :yield_yearly, :investment_cycle, :risk_rank, :borrowing_total, :min_investment_amount, :latest_payment_date, :latest_expire_date, :repay_type, :introduction, :assets_explain, :risk_control_measures, :guarantee_status, :money_flow, :credentials, files: [])
    end
    
    def weixin_login
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
                   @cure
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
    
    def get_headers
       p "===================session_helper code:#{params[:code]}======================"
      @headers = env.select {|k,v| k.start_with? 'HTTP_'}
      .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
      .collect {|pair| pair.join(": ") << "<br>"}
      .sort
    end
end
