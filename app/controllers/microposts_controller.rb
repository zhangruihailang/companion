class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    #p  "================11111111111111111==================#{params[:micropost][:avatars].length}============================"
    # p  "================3333333333333333333==================#{params[:micropost][:avatars].to_s}============================"
    #@micropost.avatars = params[:micropost][:avatars]
    if @micropost.save
      p  "=================2222222222222222=================#{@micropost.avatars.length}============================"
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  private
  
    def micropost_params
      #params.require(:micropost).permit(:content, :picture)
      params.require(:micropost).permit(:content, avatars: [])
     
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
