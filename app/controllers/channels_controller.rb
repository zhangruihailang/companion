class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:to_publish_topic_of_channel, 
                                        :publish_topic_of_channel,
                                        :to_upload_topic_pic,
                                         :upload_topic_pics,
                                         :delete_channel_topic
                                         ]
  before_action :is_admin_user, only: [:index, :search_channels, :show, :new, :update, :edit, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:destroy,:search_channels]
  # GET /channels
  # GET /channels.json
  def index
    #@channels = Channel.all
    #@likeds = @micropost.likeds
    @page_num = 0
    @channel_class = ChannelClass.find(params[:id])
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@channel_class.channels.count(:id).to_i - 1)/page_size )+1
    @channels = @channel_class.channels.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    #fresh_when(etag: [@channels])
    render 'index', :layout => 'admin'
  end
  
  def show_channels_of_class
    @page_num = 0
    @channel_class = ChannelClass.find(params[:class_id])
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 20
    @total_page = ((@channel_class.channels.count(:id).to_i - 1)/page_size )+1
    @channels = @channel_class.channels.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
   
  end
  
  def search_channels
    @channel_class = ChannelClass.find(params[:id])
    @keyword = params[:keyword]
     @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@channel_class.channels.where("title like ? or intro like ?", "%#{@keyword}%", "%#{@keyword}%").count(:id).to_i - 1)/page_size )+1
    @channels = @channel_class.channels.where("title like ? or intro like ?", "%#{@keyword}%", "%#{@keyword}%").order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    #fresh_when(etag: [@channels])
    render 'index', :layout => 'admin'
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    render 'show', :layout => 'admin'
  end

  # GET /channels/new
  def new 
    @channel = Channel.new
    @channel_class = ChannelClass.find(params[:class_id])
    render 'new', :layout => 'admin'
  end

  # GET /channels/1/edit
  def edit
    @channel_class = ChannelClass.find(params[:class_id])
     render 'edit', :layout => 'admin'
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
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    #fresh_when(etag: [@topics])
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
         @headers = env.select {|k,v| k.start_with? 'HTTP_'}
           .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
           .collect {|pair| pair.join(": ") << "<br>"}
           .sort
            if @headers.to_s.downcase.include?('micromessenger')
              redirect_to "/to_upload_topic_pic_weixin?topic_id=#{@topic.id}"
            else
              redirect_to "/to_upload_topic_pic?topic_id=#{@topic.id}"
            end
         
       end
       
     else
       flash[:danger] = "发表失败，请重新发布!"
       redirect_to '/to_publish_topic_of_channel'
     end
  end
  
  def to_upload_topic_pic
    @topic = Topic.find(params[:topic_id])
  end
  
  def to_upload_topic_pic_weixin
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
  
  def upload_topic_pics_weixin
    @topic = Topic.find(params[:topic_id])
     
    access_token = get_access_token
    serverIds = params[:serverIds]
    if serverIds
      Rails.logger.info "-----------------------serverIds=#{serverIds}--------------------------------------"

      serverIds.split('||').each do |media_id|
        Rails.logger.info "---------------------media_id=#{media_id}--------------------------------------"

         file_name = get_file_from_wexin(access_token,media_id)
         file = File.new("#{file_name}")
         Rails.logger.info "---------------------file=#{file_name}--------------------------------------"

         @topic.topic_pics.create!(:file => file)
         File.delete("#{file_name}")
      end
    end
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     redirect_to "/to_upload_topic_pic_weixin?topic_id=#{@topic.id}"
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
    # @channel = Channel.new(channel_params)
    @channel_class = ChannelClass.find(params[:class_id])
    @channel = @channel_class.channels.new(channel_params)
    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: '文章创建成果.' }
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
        format.html { redirect_to @channel, notice: '文章更新成功.' }
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
    @channel = @channel || Channel.find(params[:id])
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to "/channels?id=#{@channel.channel_class.id}", notice: '文章删除成功.' }
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
      params.require(:channel).permit(:user_id, :title, :intro, :picture,:content)
    end
end
