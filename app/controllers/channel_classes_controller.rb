class ChannelClassesController < ApplicationController
  before_action :set_channel_class, only: [:show, :edit, :update, :destroy]

  before_action :logged_in_user
  before_action :is_admin_user, only: [:index, :search_channel_classes, :show, :new, :update, :edit, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:destroy,:search_channel_classes]
  # GET /channel_classes
  # GET /channel_classes.json
  def index
    @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((ChannelClass.all.count(:id).to_i - 1)/page_size )+1
    @channels = ChannelClass.all.order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    #fresh_when(etag: [@channels])
    render 'index', :layout => 'admin'
  end
  
  def search_channel_classes
    @keyword = params[:keyword]
     @page_num = 0
    if params[:page_num]
      @page_num =  params[:page_num]
    end
    page_size = 5
    @total_page = ((ChannelClass.where("title like ? or intro like ?", "%#{@keyword}%", "%#{@keyword}%").count(:id).to_i - 1)/page_size )+1
    @channels = ChannelClass.where("title like ? or intro like ?", "%#{@keyword}%", "%#{@keyword}%").order("updated_at desc").limit(page_size).offset(@page_num.to_i * page_size.to_i)
    
    Rails.logger.info "-----------------------page_num=#{@page_num}--------------------------------------"
    Rails.logger.info "-----------------------total_page=#{@total_page}--------------------------------------"
    
    #fresh_when(etag: [@channels])
    render 'index', :layout => 'admin'
  end

  # GET /channel_classes/1
  # GET /channel_classes/1.json
  def show
    render 'show', :layout => 'admin'
  end

  # GET /channels/new
  def new 
    @channel_class = ChannelClass.new
    render 'new', :layout => 'admin'
  end

  # GET /channels/1/edit
  def edit
     render 'edit', :layout => 'admin'
  end

  # POST /channel_classes
  # POST /channel_classes.json
  def create
    @channel_class = ChannelClass.new(channel_class_params)

    respond_to do |format|
      if @channel_class.save
        format.html { redirect_to @channel_class, notice: '频道创建成功.' }
        format.json { render :show, status: :created, location: @channel_class }
      else
        format.html { render :new }
        format.json { render json: @channel_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_classes/1
  # PATCH/PUT /channel_classes/1.json
  def update
    respond_to do |format|
      if @channel_class.update(channel_class_params)
        format.html { redirect_to @channel_class, notice: '频道修改成功.' }
        format.json { render :show, status: :ok, location: @channel_class }
      else
        format.html { render :edit }
        format.json { render json: @channel_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_classes/1
  # DELETE /channel_classes/1.json
  def destroy
    
    @channel = @channel || ChannelClass.find(params[:id])
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channel_classes_url, notice: '频道删除成功.' }
      format.json { head :no_content }
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_class
      @channel_class = ChannelClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def channel_class_params
      params.require(:channel_class).permit(:title, :intro, :picture)
    end
end
