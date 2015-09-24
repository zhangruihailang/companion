class MicropostsController < ApplicationController
  
  before_action :logged_in_user, only: [:create, :destroy, :post_comment, :to_post_comment]#,:upload_pics,:upload_msg_pic]
  before_action :correct_user, only: [:destroy, :delete_micropost]
  skip_before_filter :verify_authenticity_token, only: [:destroy,:like,:unlike]
  after_action :get_weixin_openid, only: [:upload_pics,:upload_msg_pic]
  # before_action :get_weixin_openid,except: [:upload_pics,:upload_msg_pic]
  # before_action :put_weixin_openid,except: [:upload_pics,:upload_msg_pic]
  
  def like
    @micropost = Micropost.find(params[:postid])
    if current_user.nil?
      render text: "no_login"
    else
      @micropost.like(current_user.id,@micropost.user.id)
      render text: "liked"
    end
    
  end
  
  def unlike
    @micropost = Micropost.find(params[:postid])
    if current_user.nil?
      render text: "no_login"
    else
      @micropost.unlike(current_user.id)
      render text: "unliked"
    end
  end
  
  def post_comment
    @micropost = Micropost.find(params[:post_id])
    content = params[:content]
    @micropost.post_comments.create(:post_user_id => current_user.id, :content => content)
    #render 'post_comments'
    redirect_to "/post_comments?id=#{@micropost.id}"
  end
  
  def to_post_comment
    @micropost = Micropost.find(params[:post_id])
    @is_reply = params[:reply]
    @comment_user = User.find(params[:to_user_id])
  end
  
  def post_comments
    @micropost = Micropost.find(params[:id])
    
    #@likeds = @micropost.likeds
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@micropost.post_comments.count(:id).to_i - 1)/page_size )+1
    @post_comments = @micropost.post_comments.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  
  def delete_comment
    
    @comment = PostComment.find(params[:id])
    @comment.destroy
    
    #flash[:success] = "Micropost deleted"
    #redirect_to request.referrer || root_url
    redirect_to "/post_comments?id=#{@comment.micropost.id}"
  end
  
  def show_post_likeds
    @micropost = Micropost.find(params[:post_id])
    #@likeds = @micropost.likeds
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@micropost.likeds.count(:id).to_i - 1)/page_size )+1
    @likeds = @micropost.likeds.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end
  
  
  
  def create
    # @micropost = current_user.microposts.build(micropost_params)
    # if @micropost.save
    #   flash[:success] = "Micropost created!"
    #   redirect_to root_url
    # else
    #   @feed_items = []
    #   render 'static_pages/home'
    # end
    @micropost = current_user.microposts.build(micropost_params)
     if @micropost.save
        # if params[:files] && params[:files].any? 
        #   params[:files].each do |file|
        #   @attachment = @micropost.message_pic.create!(:file => file)
        #   #@pic_urls += ",#{@attachment.file.url('400')}"
        #   end
        # end
        p '------------------发表成功!------------------------------'
       
       #render ''
       if params[:if_completed] == 'yes'
          flash[:success] = "发表成功!"
          redirect_to "/"
       else
        @headers = env.select {|k,v| k.start_with? 'HTTP_'}
           .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
           .collect {|pair| pair.join(": ") << "<br>"}
           .sort
            if @headers.to_s.downcase.include?('micromessenger')
              redirect_to "/upload_msg_pic_weixin?id=#{@micropost.id}"
            else
              redirect_to "/upload_msg_pic?id=#{@micropost.id}"
            end
         
       end
       
     else
       flash[:danger] = "发表失败，请重新发布!"
       redirect_to '/publish_message'
     end

  end
  
  def upload_msg_pic
    @micropost = Micropost.find(params[:id])
  end
  
  def upload_msg_pic_weixin
    @micropost = Micropost.find(params[:id])
  end
  
  def upload_pics
     
     @micropost = Micropost.find(params[:message_id])
     if params[:files] && params[:files].any? 
        params[:files].each do |file|
        #@attachment = @micropost.message_pic.create!(:file => file)
        @attachment = @micropost.message_pics.new
        @attachment.file = file
        @attachment.save
        #@pic_urls += ",#{@attachment.file.url('400')}"
        end
     end
     
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     render 'upload_msg_pic'
  end
  
  def upload_pics_weixin
    @micropost = Micropost.find(params[:message_id])
    access_token = get_access_token
    serverIds = params[:serverIds]
    if serverIds
      Rails.logger.info "-----------------------serverIds=#{serverIds}--------------------------------------"

      serverIds.split('||').each do |media_id|
        Rails.logger.info "---------------------media_id=#{media_id}--------------------------------------"

         file = get_file_from_wexin(access_token,media_id)
         Rails.logger.info "---------------------file=#{file.name}--------------------------------------"

         @micropost.message_pics.create!(:file => file)
         File.delete("./#{file.name}")
      end
    end
    
   
   
    # if params[:files] && params[:files].any? 
    #     params[:files].each do |file|
    #     #@attachment = @micropost.message_pic.create!(:file => file)
    #     @attachment = @micropost.message_pics.new
    #     @attachment.file = file
    #     @attachment.save
    #     #@pic_urls += ",#{@attachment.file.url('400')}"
    #     end
    # end
     
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
    # render 'upload_msg_pic_weixin'
    Rails.logger.info "-----------------------redirect_to=/upload_msg_pic_weixin?id=#{@micropost.id}--------------------------------------"

    redirect_to "/upload_msg_pic_weixin?id=#{@micropost.id}"
  end
  
  def destroy
    @micropost.destroy
    #flash[:success] = "Micropost deleted"
    #redirect_to request.referrer || root_url
    flash[:success] = "删除成功！"
    redirect_to root_url
  end
  
  def delete_micropost
    #@micropost = Micropost.find(params[:id])
    @micropost.destroy
    #flash[:success] = "Micropost deleted"
    #redirect_to request.referrer || root_url
    flash[:success] = "删除成功！"
    redirect_to root_url
  end
  
  private
  
    def micropost_params
      #params.require(:micropost).permit(:content, :picture)
      params.require(:micropost).permit(:content, files: [])
     
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
