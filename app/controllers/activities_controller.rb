class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,except: [:activity_comments]
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  before_action :correct_user, only: [:destroy, :delete_activity]
  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    #@activity = Activity.new(activity_params)
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      if params[:if_completed] == 'yes'
          flash[:success] = "发布成功!"
          redirect_to "/activities"
       else
         #redirect_to "/upload_activity_pic?id=#{@activity.id}"
         @headers = env.select {|k,v| k.start_with? 'HTTP_'}
           .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
           .collect {|pair| pair.join(": ") << "<br>"}
           .sort
            if @headers.to_s.downcase.include?('micromessenger')
              redirect_to "/upload_activity_pic_weixin?id=#{@activity.id}"
            else
              redirect_to "/upload_activity_pic?id=#{@activity.id}"
            end
       end
       
    else
      redirect_to '/activities/new'
    end
    # respond_to do |format|
    #   if @activity.save
    #     format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
    #     format.json { render :show, status: :created, location: @activity }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @activity.errors, status: :unprocessable_entity }
    #   end
    # end
  end


  def upload_activity_pic
    
    @activity = Activity.find(params[:id])
    #render 'upload_activity_pic'
  end
  
  def upload_activity_pic_weixin
    @activity = Activity.find(params[:id])
  end
  
  def test
    
  end
  
  def upload_pics
     
    @activity = Activity.find(params[:activity_id])
    
    if params[:files] && params[:files].any? 
        params[:files].each do |file|
        #@attachment = @micropost.message_pic.create!(:file => file)
        @activity.activity_pics.create!(:file => file)
        # @attachment = @activity.activity_pics.new
        # @attachment.file = file
        # @attachment.save
        #@pic_urls += ",#{@attachment.file.url('400')}"
        end
    end
   

     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     render 'upload_activity_pic'
  end
  
  def upload_pics_weixin
    
    @activity = Micropost.find(params[:activity_id])
    access_token = get_access_token
    serverIds = params[:serverIds]
    if serverIds
      Rails.logger.info "-----------------------serverIds=#{serverIds}--------------------------------------"

      serverIds.split('||').each do |media_id|
        Rails.logger.info "---------------------media_id=#{media_id}--------------------------------------"

         file_name = get_file_from_wexin(access_token,media_id)
         file = File.new("#{file_name}")
         Rails.logger.info "---------------------file=#{file_name}--------------------------------------"

         @activity.activity_pics.create!(:file => file)
         File.delete("#{file_name}")
      end
    end
    
    redirect_to "/upload_activity_pic_weixin?id=#{@activity.id}"
    
  end
  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def activity_comments
    @activity = Activity.find(params[:id])
    
    #@likeds = @micropost.likeds
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@activity.activity_comments.count(:id).to_i - 1)/page_size )+1
    @activity_comments = @activity.activity_comments.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def to_activity_comment
    @activity = Activity.find(params[:post_id])
    @is_reply = params[:reply]
    @comment_user = User.find(params[:to_user_id])
  end

  def post_activity_comment
    @activity = Activity.find(params[:post_id])
    content = params[:content]
    @activity.activity_comments.create(:post_user_id => current_user.id, :content => content)
    #render 'post_comments'
    redirect_to "/activity_comments?id=#{@activity.id}"
  end
  # DELETE /activities/1
  # DELETE /activities/1.json
  
  def delete_activity_comment
    
    @comment = ActivityComment.find(params[:id])
    @comment.destroy
    
    #flash[:success] = "Micropost deleted"
    #redirect_to request.referrer || root_url
    redirect_to "/activity_comments?id=#{@comment.activity.id}"
  end
  
  def show_activity_applies
     @activity = Activity.find(params[:post_id])
    #@likeds = @micropost.likeds
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@activity.activity_applies.count(:id).to_i - 1)/page_size )+1
    @activity_applies = @activity.activity_applies.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end
  
  def apply_activity
    @activity = Activity.find(params[:activity_id])
  
    if @activity.has_applied?(current_user.id)
      flash[:success] = "您已经报过名!"
    elsif @activity.user == current_user
      flash[:success] = "这是您发布的活动，不需要报名!"
    else
      @activity.apply(current_user.id)
      flash[:success] = "报名成功!"
    end
    
    redirect_to "/activity_comments?id=#{@activity.id}"
  end
  
  def cancel_activity_apply
    apply = ActivityApply.find(params[:apply_id])
    apply.destroy
    flash[:success] = "取消报名成功!"
    redirect_to "/activity_comments?id=#{apply.activity.id}"
  end
  
  def delete_activity
    #@activity = Activity.find(params[:id])
    @activity.destroy
    flash[:success] = "删除成功！"
    redirect_to '/activities'
  end
  
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: '' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:title, :description, :starttime, :endtime, :place, :number_of_people, :pay_type, :average_cost, :user_id, :tags, :apply_up_limit)
    end
    
    def correct_user
      @activity = current_user.activities.find_by(id: params[:id])
      redirect_to root_url if @activity.nil?
    end
end
