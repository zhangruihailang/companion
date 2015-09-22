class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :get_home_data
  before_action :logged_in_user,only: [:to_publish_topic_of_category]
  # GET /categories
  # GET /categories.json
  def index
    @my_categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def to_publish_topic_of_category
    @categories = Category.all
  end
  
  def publish_topic_of_category
    @category = Category.find(params[:category_id])
    @topic = @category.topics.build(:user_id => current_user.id,:content => params[:content],:topic_type => 'category',:title => params[:title])
     if @topic.save
       
      p '------------------发表成功!------------------------------'
       
      flash[:success] = "发表成功!"
      redirect_to "/topics_of_category?id=#{@category.id}"
     
       
     else
       flash[:danger] = "发表失败，请重新发布!"
       redirect_to '/to_publish_topic_of_category'
     end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
end
