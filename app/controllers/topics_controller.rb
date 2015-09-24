class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:destroy,:like,:unlike,:comment_like,:comment_unlike]
  before_action :logged_in_user ,except: [:index, :show, :topic_comments, :show_topic_likes,:like,:unlike,:comment_like,:comment_unlike]
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def like
    @topic = Topic.find(params[:topicid])
    if current_user.nil?
      render text: "no_login"
    else
      @topic.like(current_user.id)
      render text: "liked"
    end
    
  end
  
  def unlike
    @topic = Topic.find(params[:topicid])
    if current_user.nil?
      render text: "no_login"
    else
      @topic.unlike(current_user.id)
      render text: "unliked"
    end
  end

  def comment_like
    @topic_comment = TopicComment.find(params[:commentid])
    if current_user.nil?
      render text: "no_login"
    else
      @topic_comment.like(current_user.id)
      render text: "liked"
    end
    
  end
  
  def comment_unlike
    @topic_comment = TopicComment.find(params[:commentid])
    if current_user.nil?
      render text: "no_login"
    else
      @topic_comment.unlike(current_user.id)
      render text: "unliked"
    end
  end


  def show_topic_likes
    @topic = Topic.find(params[:topic_id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@topic.topic_likes.count(:id).to_i - 1)/page_size )+1
    @likes = @topic.topic_likes.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    #fresh_when(etag: [@likes])
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  
  def delete_comment
    @topic_comment  = TopicComment.find(params[:id])
    @topic_comment.destroy
    flash[:success] = "删除成功！"
    redirect_to "/topic_comments?id=#{@topic_comment.topic.id}"
  end
  
  
  
  def topic_comments
    @topic = Topic.find(params[:id])
    
    if logged_in?
      @topic.topic_reads.create(:user_id => current_user.id)
    else
      @topic.topic_reads.create()
    end
    
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@topic.topic_comments.count(:id).to_i - 1)/page_size )+1
    @comments = @topic.topic_comments.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    @hot5_comments = @topic.topic_comments.sort_by {|comment| comment.topic_comment_likes.count}.reverse[0..4]
    Rails.logger.info "----------------------------------------------------@hot5_comments.count:#{@hot5_comments.count}"
    #fresh_when :etag => [@comments, @hot5_comments]
    
  end
  
  def to_post_topic_comment
    @topic = Topic.find(params[:topic_id])
    @is_reply = params[:reply]
    @comment_user = User.find(params[:to_user_id])
  end
  
  def post_topic_comment
    @topic = Topic.find(params[:topic_id])
    content = params[:content]
    @topic.topic_comments.create(:user_id => current_user.id, :content => content)
    #render 'post_comments'
    redirect_to "/topic_comments?id=#{@topic.id}"
  end
  
  
  def delete_topic
    @topic = Topic.find(params[:id])
    topic_type = @topic.topic_type
    @topic.destroy
    flash[:success] = "删除成功！"
    if topic_type == 'channel'
      redirect_to "/topics_of_channel?id=#{@topic.channel.id}"
    elsif topic_type == 'category'
      redirect_to "/topics_of_category?id=#{@topic.category.id}"
    else
      redirect_to "/topics_of_category"
    end
    
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:user_id, :category_id, :channel_id, :title, :content)
    end
end
