class OrganizationsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  before_filter :has_organization, :only => [:index]
  before_filter :is_admin, :only => [:verify]
  def index
  end

  def show
    @organization = Organization.find_by_name(params[:organization].titleize)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.organizations.build(params[:organization])
    if @organization.save
      flash[:success] = "Congratulations, your organization was created! An email was sent to the AustinProBono team telling them about you, and requesting they contact you for verification."
      redirect_to new_organization_project_path(@organization)
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

  def verify
    @organization = Organization.find_by_verification_token(params[:id])
    if @organization
      @organization.toggle!(:verified)
      flash.now[:success] = "#{@organization.name} has been verified!"
    else
      flash.now[:error] = "The organization could not be found"
    end
  end

  private

  def has_organization
    redirect_to new_organization_path unless current_user.organizations.count > 0
  end

end
