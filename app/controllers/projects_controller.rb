class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    # files = params[:files]
    # files.each do |file|
    #   #p "------------------------------------------------------------------------------------------"
    #   attachment = Attachment.new
    #   attachment.project_id = @project.id
    #   attachment.file = file
    #   attachment.save
    # end
    respond_to do |format|
      if @project.save
        
        params[:files].each do |file|
          @attachment = @project.attachments.create!(:file => file)
        end
        
        format.html { redirect_to @project, notice: '项目发布成功.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :yield_yearly, :investment_cycle, :risk_rank, :borrowing_total, :min_investment_amount, :latest_payment_date, :latest_expire_date, :repay_type, :introduction, :assets_explain, :risk_control_measures, :guarantee_status, :money_flow, :credentials, files: [])
    end
end
