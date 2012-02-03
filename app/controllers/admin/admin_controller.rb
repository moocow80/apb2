class Admin::AdminController < ApplicationController
  layout "admin"
  before_filter :is_admin

  def is_admin
    unless current_user && current_user.is_admin?
      flash[:error] = "Sorry, you don't have access to this area."
      redirect_to login_path
    end
  end
end
