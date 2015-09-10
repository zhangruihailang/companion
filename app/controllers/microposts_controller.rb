class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
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
       flash[:success] = "发表成功!"
       #render ''
       redirect_to "/upload_msg_pic?id=#{@micropost.id}"
     else
       flash[:danger] = "发表失败，请重新发布!"
       redirect_to '/publish_message'
     end

  end
  
  def upload_msg_pic
    @micropost = Micropost.find(params[:id])
  end
  
  def upload_pics
     
     @micropost = Micropost.find(params[:message_id])
     if params[:files] && params[:files].any? 
        params[:files].each do |file|
        #@attachment = @micropost.message_pic.create!(:file => file)
        @attachment = @micropost.message_pic.new
        @attachment.file = file
        @attachment.save
        #@pic_urls += ",#{@attachment.file.url('400')}"
        end
     end
     
     flash[:notice] = "发布成功"
     render 'upload_msg_pic'
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
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
