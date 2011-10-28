class OrganizationsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  before_filter :has_organization, :only => [:index]
  def index
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.organizations.build(params[:organization])
    if @organization.save
      flash[:success] = "Congratulations, your organization was create!"
      redirect_to organizations_new_project_path(@organization)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def has_organization
    redirect_to new_organization_path unless current_user.organizations.count > 0
  end

end
