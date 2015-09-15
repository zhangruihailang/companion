class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  skip_before_filter :verify_authenticity_token, only: [:destroy]
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
         redirect_to "/upload_activity_pic?id=#{@activity.id}"
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
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
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
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end
  
  def apply_activity
    @activity = Activity.find(params[:activity_id])
  
    if @activity.has_applied?(current_user.id)
      flash[:success] = "您已经报过名!"
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
end
