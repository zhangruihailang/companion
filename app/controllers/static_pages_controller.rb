class StaticPagesController < ApplicationController
  before_action :get_home_data
  require 'download'
  require 'net/http'
  def home
    #if logged_in?
    #@micropost = current_user.microposts.build
    #@feed_items = current_user.feed.paginate(page: params[:page])
    #@feed_items = current_user.feed.paginate(page: params[:page])
    
    #end
    # @projects = Project.all
    # @code = params[:code]
    # Rails.logger.info "---------------------@code=#{@code}-------------------------------"
    
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
    @tab_id = params[:id] || '0'
    
    #if @tab_id == '0'
      @microposts = Micropost.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    #end
    
    # if @tab_id == '1'
    #   @microposts = Micropost.where( : => 'Ruby' ).order("updated_at").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    # end
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    
  end
  
  
  def topics_of_category
    @categories = Category.all
    
    @tab_id = params[:id] || ''
    
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    
    if @tab_id == ''
      # @topics = []
      # Category.all.each do |category|
      #   category.topics.each do |topic| 
      #     @topics.push(topic)
      #   end
      # end
      @topics = Topic.where(:topic_type => 'category').order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    else  
      @topics = Category.find(@tab_id).topics.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    end
   
    
    @total_page = ((@topics.count(:id).to_i - 1)/page_size )+1
    
    
    #if @tab_id == '0'
    #@topics = @topics.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    #end
    
    # if @tab_id == '1'
    #   @microposts = Micropost.where( : => 'Ruby' ).order("updated_at").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    # end
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def activities
     @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((Activity.count(:id).to_i - 1)/page_size )+1
    @tab_id = params[:id] || '0'
    
    #if @tab_id == '0'
      @activities = Activity.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    #end
    
    # if @tab_id == '1'
    #   @microposts = Micropost.where( : => 'Ruby' ).order("updated_at").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    # end
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end
  
  def channels
     @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 20
    @total_page = ((Channel.all.count(:id).to_i - 1)/page_size )+1
    @channels = Channel.all.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def download_pic_from_weixin
    midia_id = params[:midia_id]
    access_token = get_access_token
    uri_path = "http://file.api.weixin.qq.com"
    target_local_file_path = "/cgi-bin/media/get?access_token=#{access_token}&media_id=#{midia_id}"
    Rails.logger.info "---------------------------midia_id:#{midia_id}-----------------------------------"
    Rails.logger.info "---------------------------access_token:#{access_token}-----------------------------------"
    Rails.logger.info "---------------------------uri_path:#{uri_path}-----------------------------------"
    Rails.logger.info "---------------------------target_local_file_path:#{target_local_file_path}-----------------------------------"
    file = Download.file(uri_path,target_local_file_path)
    render :json => { :smscode => "#{file.path}"}
  end
  
end
