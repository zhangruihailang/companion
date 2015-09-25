class GoodsController < ApplicationController
  before_action :set_good, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, except: [:index,:show,:show_good_likes]
  skip_before_filter :verify_authenticity_token, only: [:destroy,:like,:unlike]
  # GET /goods
  # GET /goods.json
  def like
    @good = Good.find(params[:goodid])
    if current_user.nil?
      render text: "no_login"
    else
      @good.like(current_user.id)
      render text: "liked"
    end
    
  end
  
  def unlike
    @good = Good.find(params[:goodid])
    if current_user.nil?
      render text: "no_login"
    else
      @good.unlike(current_user.id)
      render text: "unliked"
    end
  end
  
  def delete_good
     @good = Good.find(params[:id])
     @good.destroy
     redirect_to "/goods"
  end

  def delete_comment
    @good_comment  = GoodComment.find(params[:id])
    @good_comment.destroy
    flash[:success] = "删除成功！"
    redirect_to "/good_comments?id=#{@good_comment.good.id}"
  end
  
  
  
  def good_comments
    @good = Good.find(params[:id])
    
    if logged_in?
      @good.good_reads.create(:user_id => current_user.id)
    else
      @good.good_reads.create()
    end
    
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    
    page_size = 5
    @total_page = ((@good.good_comments.count(:id).to_i - 1)/page_size )+1
    @comments = @good.good_comments.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    
  end
  
  def to_post_good_comment
    @good = Good.find(params[:good_id])
    @is_reply = params[:reply]
    @comment_user = User.find(params[:to_user_id])
  end
  
  def post_good_comment
    @good = Good.find(params[:good_id])
    content = params[:content]
    @good.good_comments.create(:user_id => current_user.id, :content => content)
    #render 'post_comments'
    redirect_to "/good_comments?id=#{@good.id}"
  end

  
  def show_good_likes
    @good = Good.find(params[:good_id])
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((@good.good_likes.count(:id).to_i - 1)/page_size )+1
    @likes = @good.good_likes.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    #fresh_when(etag: [@likes])
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
  end
  
  def index
    # @goods = Good.all
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((Good.count(:id).to_i - 1)/page_size )+1
    @tab_id = params[:id] || '0'
    
    #if @tab_id == '0'
      @goods = Good.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    #end
    
    # if @tab_id == '1'
    #   @microposts = Micropost.where( : => 'Ruby' ).order("updated_at").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    # end
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
  end

  # GET /goods/1
  # GET /goods/1.json
  def show
  end

  # GET /goods/new
  def new
    @good = Good.new
  end

  # GET /goods/1/edit
  def edit
  end

  # POST /goods
  # POST /goods.json
  def create
    @good = Good.new(good_params)

    if @good.save
      if params[:if_completed] == 'yes'
          flash[:success] = "发布成功!"
          redirect_to "/goods"
       else
         #redirect_to "/upload_activity_pic?id=#{@activity.id}"
         @headers = env.select {|k,v| k.start_with? 'HTTP_'}
           .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
           .collect {|pair| pair.join(": ") << "<br>"}
           .sort
            if @headers.to_s.downcase.include?('micromessenger')
              redirect_to "/to_upload_good_pic_weixin?good_id=#{@good.id}"
            else
              redirect_to "/to_upload_good_pic?good_id=#{@good.id}"
            end
       end
    else
       flash[:success] = "发布失败，请重新发布!"
      render :new 
    end
    # respond_to do |format|
    #   if @good.save
    #     format.html { redirect_to @good, notice: 'Good was successfully created.' }
    #     format.json { render :show, status: :created, location: @good }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @good.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def to_upload_good_pic
    @good = Good.find(params[:good_id])
  end
  
  def to_upload_good_pic_weixin
    @good = Good.find(params[:good_id])
  end
  
  def upload_good_pics
     @good = Good.find(params[:good_id])
     if params[:files] && params[:files].any? 
        params[:files].each do |file|
        #@attachment = @micropost.message_pic.create!(:file => file)
        @attachment = @good.good_pics.new
        @attachment.file = file
        @attachment.save
        #@pic_urls += ",#{@attachment.file.url('400')}"
        end
     end
     
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     render 'to_upload_good_pic'
  end
  
  def upload_good_pics_weixin
    @good = Good.find(params[:good_id])
     
    access_token = get_access_token
    serverIds = params[:serverIds]
    if serverIds
      Rails.logger.info "-----------------------serverIds=#{serverIds}--------------------------------------"

      serverIds.split('||').each do |media_id|
        Rails.logger.info "---------------------media_id=#{media_id}--------------------------------------"

         file_name = get_file_from_wexin(access_token,media_id)
         file = File.new("#{file_name}")
         Rails.logger.info "---------------------file=#{file_name}--------------------------------------"

         @good.good_pics.create!(:file => file)
         File.delete("#{file_name}")
      end
    end
     #flash[:notice] = "您可以继续选择图片上传或者点击完成按钮"
     redirect_to "/to_upload_good_pic_weixin?good_id=#{@good.id}"
  end


    
  # PATCH/PUT /goods/1
  # PATCH/PUT /goods/1.json
  def update
    respond_to do |format|
      if @good.update(good_params)
        format.html { redirect_to @good, notice: 'Good was successfully updated.' }
        format.json { render :show, status: :ok, location: @good }
      else
        format.html { render :edit }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goods/1
  # DELETE /goods/1.json
  def destroy
    @good.destroy
    respond_to do |format|
      format.html { redirect_to goods_url, notice: 'Good was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_good
      @good = Good.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def good_params
      params.require(:good).permit(:title, :description, :price, :original_price, :freight, :user_id, :good_class_id)
    end
end
