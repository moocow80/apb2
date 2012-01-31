class UserOrganizationsController < ApplicationController
  before_filter :authenticate

  def index
    @organizations = Organization.where(:user_id => current_user.id)
  end

  def projects
    @organization = Organization.find_by_slug(params[:id])
  end
end
