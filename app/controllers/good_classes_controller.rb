class GoodClassesController < ApplicationController
  before_action :set_good_class, only: [:show, :edit, :update, :destroy]

  # GET /good_classes
  # GET /good_classes.json
  def index
    @good_classes = GoodClass.all
  end

  # GET /good_classes/1
  # GET /good_classes/1.json
  def show
  end

  # GET /good_classes/new
  def new
    @good_class = GoodClass.new
  end

  # GET /good_classes/1/edit
  def edit
  end

  # POST /good_classes
  # POST /good_classes.json
  def create
    @good_class = GoodClass.new(good_class_params)
    
    respond_to do |format|
      if @good_class.save
        @good_classes = GoodClass.all
        format.html { render :index, notice: 'Good class was successfully created.' }
        format.json { render :show, status: :created, location: @good_class }
      else
        format.html { render :new }
        format.json { render json: @good_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /good_classes/1
  # PATCH/PUT /good_classes/1.json
  def update
    respond_to do |format|
      if @good_class.update(good_class_params)
        format.html { redirect_to @good_class, notice: 'Good class was successfully updated.' }
        format.json { render :show, status: :ok, location: @good_class }
      else
        format.html { render :edit }
        format.json { render json: @good_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /good_classes/1
  # DELETE /good_classes/1.json
  def destroy
    @good_class.destroy
    respond_to do |format|
      format.html { redirect_to good_classes_url, notice: 'Good class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_good_class
      @good_class = GoodClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def good_class_params
      params.require(:good_class).permit(:name, :parent_id)
    end
end
