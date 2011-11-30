class ProjectsController < ApplicationController
  before_filter :authenticate
  before_filter :find_organization, :except => [:index, :matches, :verify]
  before_filter :is_admin, :only => [:verify]

  def index
  end

  def show
  end

  def new
    organization = Organization.find_by_name(params[:organization].titleize)
    @project = organization.projects.new
    @tags = Tag.where(:tag_type => "category")
  end

  def create
    organization = Organization.find_by_name(params[:organization].titleize)
    @project = organization.projects.create(params[:project])
    @project.status = "open"
    if @project.save
      flash[:success] = "Your project was created!"
      redirect_to organization_path(organization)
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

  def matches
    if !current_user.verified?
      flash[:error] = "Sorry, you can't see your matches until your email address has been verified."
      redirect_to user_path(current_user)
    end
  end

  def verify
    @project = Project.find_by_verification_token(params[:id])
    if @project
      @project.toggle!(:verified)
      flash.now[:success] = "#{@project.name} has been verified!"
    else
      flash.now[:error] = "The project could not be found"
    end
  end

  private

  def find_organization
    unless Organization.find_by_name(params[:organization].titleize)
      flash[:error] = "Organization was not found."
      redirect_to organizations_path
    end
  end

end
