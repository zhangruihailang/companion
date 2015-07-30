require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { assets_explain: @project.assets_explain, borrowing_total: @project.borrowing_total, credentials: @project.credentials, guarantee_status: @project.guarantee_status, introduction: @project.introduction, investment_cycle: @project.investment_cycle, latest_expire_date: @project.latest_expire_date, latest_payment_date: @project.latest_payment_date, min_investment_amount: @project.min_investment_amount, money_flow: @project.money_flow, name: @project.name, repay_type: @project.repay_type, risk_control_measures: @project.risk_control_measures, risk_rank: @project.risk_rank, yield_yearly: @project.yield_yearly }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { assets_explain: @project.assets_explain, borrowing_total: @project.borrowing_total, credentials: @project.credentials, guarantee_status: @project.guarantee_status, introduction: @project.introduction, investment_cycle: @project.investment_cycle, latest_expire_date: @project.latest_expire_date, latest_payment_date: @project.latest_payment_date, min_investment_amount: @project.min_investment_amount, money_flow: @project.money_flow, name: @project.name, repay_type: @project.repay_type, risk_control_measures: @project.risk_control_measures, risk_rank: @project.risk_rank, yield_yearly: @project.yield_yearly }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
