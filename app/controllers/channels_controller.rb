class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:to_publish_topic_of_channel, 
                                        :publish_topic_of_channel,
                                        :to_upload_topic_pic,
                                         :upload_topic_pics,
                                         :delete_channel_topic
                                         ]
  # GET /channels
  # GET /channels.json
  def index
    #@channels = Channel.all
    #@likeds = @micropost.likeds
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((Channel.all.count(:id).to_i - 1)/page_size )+1
    @channels = Channel.all.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
  end


  def topics_of_channel
    @channel = Channel.find(params[:id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@channel.topics.count(:id).to_i - 1)/page_size )+1
    @topics = @channel.topics.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def to_publish_topic_of_channel
     @channel = Channel.find(params[:channel_id])
  end
 
  def publish_topic_of_channel
    @channel = Channel.find(params[:channel_id])
    @topic = @channel.topics.build(:user_id => current_user.id,:content => params[:content],:topic_type => 'channel')
     if @topic.save
       
        p '------------------发表成功!------------------------------'
       
       #render ''
       if params[:if_completed] == 'yes'
          flash[:success] = "发表成功!"
          redirect_to "/topics_of_channel?id=#{@channel.id}"
       else
         redirect_to "/to_upload_topic_pic?topic_id=#{@topic.id}"
       end
       
     else
       flash[:danger] = "发表失败，请重新发布!"
       redirect_to '/to_publish_topic_of_channel'
     end
  end
  
  def to_upload_topic_pic
    @topic = Topic.find(params[:topic_id])
  end
  
  def upload_topic_pics
     @topic = Topic.find(params[:topic_id])
     if params[:files] && params[:files].any? 
        params[:files].each do |file|
        #@attachment = @micropost.message_pic.create!(:file => file)
        @attachment = @topic.topic_pics.new
        @attachment.file = file
        @attachment.save
        #@pic_urls += ",#{@attachment.file.url('400')}"
        end
     end
     
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     render 'to_upload_topic_pic'
  end
  
  def delete_channel_topic
    @topic = Topic.find(params[:id])
    topic_type = @topic.topic_type
    @topic.destroy
    flash[:success] = "删除成功！"
    if topic_type == 'channel'
      redirect_to "/topics_of_channel?id=#{@topic.channel.id}"
    else
      redirect_to "/topics_of_category?id=#{@topic.category.id}"
    end
    
  end
  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1
  # PATCH/PUT /channels/1.json
  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url, notice: 'Channel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def channel_params
      params.require(:channel).permit(:user_id, :title, :intro, :picture)
    end
end