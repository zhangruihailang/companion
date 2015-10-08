class AdminController < ApplicationController
  before_action :logged_in_user
  before_action :is_admin_user
  def index
    render 'index'
  end
end
