class StaticPagesController < ApplicationController
  before_action :get_home_data
  def home
    #if logged_in?
    #@micropost = current_user.microposts.build
    #@feed_items = current_user.feed.paginate(page: params[:page])
    #@feed_items = current_user.feed.paginate(page: params[:page])
    
    #end
    # @projects = Project.all
    # @code = params[:code]
    # p "---------------------@code=#{@code}-------------------------------"
    
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def playmates
    #@microposts = Micropost.all
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((Micropost.count(:id).to_i - 1)/page_size )+1
    @microposts = Micropost.order("updated_at").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    p "-----------------------page_num=#{@page_num}--------------------------------------"
    p "-----------------------total_page=#{@total_page}--------------------------------------"
    
    @tab_id = params[:id] || '0'
  end
  
end
