class ProjectsController < ApplicationController
  before_filter :authenticate
  before_filter :find_organization, :except => [:index, :matches]
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
  end

  private

  def find_organization
    unless Organization.find_by_name(params[:organization].titleize)
      flash[:error] = "Organization was not found."
      redirect_to organizations_path
    end
  end

end
