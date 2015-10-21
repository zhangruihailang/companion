class StaticPagesController < ApplicationController
  before_action :get_home_data
  skip_before_filter :verify_authenticity_token, :only => [:download_pic_from_weixin]
  
  require 'net/http'
  #require 'download'
  require 'open-uri'  
  include StaticPagesHelper
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
    
    #fresh_when(etag: [@microposts])
    
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
    #fresh_when(etag: [@topics])
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
    #fresh_when(etag: [@activities])
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
    
    #fresh_when(etag: [@channels])
  end
  
  def channel_classes
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 20
    @total_page = ((ChannelClass.all.count(:id).to_i - 1)/page_size )+1
    @channels = ChannelClass.all.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def test_upload
    url_path = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=RNreawiHDYuUciBc6FebZgxGawDUezuQ2TT1EdntQ7AGdifmTzmJp27YcR2NJF_SMGPU-izG3ontGKC6rLrQgRQs-4DNmt9u7d0vDwonJcU&media_id=o9lECDGjp2nmF8vGujEc-4rWNEUskaorBI6VC1Gf77xPbAyHCCQ6cA6bvM_maO_j"  
    path = "/cgi-bin/media/get?access_token=RNreawiHDYuUciBc6FebZgxGawDUezuQ2TT1EdntQ7AGdifmTzmJp27YcR2NJF_SMGPU-izG3ontGKC6rLrQgRQs-4DNmt9u7d0vDwonJcU&media_id=o9lECDGjp2nmF8vGujEc-4rWNEUskaorBI6VC1Gf77xPbAyHCCQ6cA6bvM_maO_j"
    url = URI.parse(url_path)
    res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(path)
      }
    
    str = res.body
     
      open("./test.jpg", "wb") { |file|
        file.write(res.body)
        @user = User.find(3)
        @micropost = @user.microposts.create!(:content => '测试图片')
         @micropost.message_pics.create!(:file => file)
        # @attachment = @micropost.message_pics.new
        # @attachment.file = file
        # @attachment.save
       }

  end
  
  def download_pic_from_weixin
    midia_id = params[:midia_id]
    access_token = get_access_token
    # uri_path = "http://file.api.weixin.qq.com"
    # target_local_file_path = "/cgi-bin/media/get?access_token=#{access_token}&media_id=#{midia_id}"
    # Rails.logger.info "---------------------------midia_id:#{midia_id}-----------------------------------"
    # Rails.logger.info "---------------------------access_token:#{access_token}-----------------------------------"
    # Rails.logger.info "---------------------------uri_path:#{uri_path}-----------------------------------"
    # Rails.logger.info "---------------------------target_local_file_path:#{target_local_file_path}-----------------------------------"
    # file = Download.file(uri_path,target_local_file_path)
    # render :json => { :smscode => "#{file.path}"}
    url_path = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=RNreawiHDYuUciBc6FebZgxGawDUezuQ2TT1EdntQ7AGdifmTzmJp27YcR2NJF_SMGPU-izG3ontGKC6rLrQgRQs-4DNmt9u7d0vDwonJcU&media_id=o9lECDGjp2nmF8vGujEc-4rWNEUskaorBI6VC1Gf77xPbAyHCCQ6cA6bvM_maO_j"  
    path = "/cgi-bin/media/get?access_token=RNreawiHDYuUciBc6FebZgxGawDUezuQ2TT1EdntQ7AGdifmTzmJp27YcR2NJF_SMGPU-izG3ontGKC6rLrQgRQs-4DNmt9u7d0vDwonJcU&media_id=o9lECDGjp2nmF8vGujEc-4rWNEUskaorBI6VC1Gf77xPbAyHCCQ6cA6bvM_maO_j"
    url = URI.parse('http://test/testapi?wsdl')
    res = Net::HTTP.start(url_path.host, url_path.port) {|http|
        http.get(path)
      }
    
    str = res.body
     
    open("./test.jpg", "wb") { |file|
      file.write(res.body)
      @user = User.find(3)
      @micropost = @user.microposts.create!(:content => '测试图片')
      @micropost.message_pic.create!(:file => file)
    }

  end
  
end
