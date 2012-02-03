class ProjectsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]
  before_filter :find_organization, :except => [:index, :matches, :verify]
  before_filter :is_admin, :only => [:verify]
  before_filter :correct_user, :only => [:edit, :update, :destroy]

  def index
    per_page = params[:per_page] || 20
    if params[:cause_tag_ids] && params[:skill_tag_ids]
      sql = Project.with_causes_and_skills_sql(params[:cause_tag_ids].join(","), params[:skill_tag_ids].join(","))
    elsif params[:cause_tag_ids]
      sql = Project.with_causes_sql(params[:cause_tag_ids].join(","))
    elsif params[:skill_tag_ids]
      sql = Project.with_skills(params[:skill_tag_ids].join(",")).to_sql
    else
      sql = Project.verified.to_sql
    end
    @projects = Project.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
  end

  def show
    @project = Project.find_by_slug(params[:id])
  end

  def new
    organization = Organization.find_by_slug(params[:organization_id])
    @project = organization.projects.new
  end

  def create
    organization = Organization.find(params[:project][:organization_id])
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
    if @project.update_attributes(params[:project])
      flash[:success] = "Your project was successfully updated!"
      redirect_to organization_project_path(@project.organization, @project)
    else
      render :edit
    end
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
    unless Organization.find_by_slug(params[:organization_id])
      flash[:error] = "Organization was not found."
      redirect_to organizations_path
    end
  end

  def correct_user
    @project = Project.find_by_slug(params[:id])
    unless @project.organization.owner == current_user
      flash[:error] = "You are not authorized to edit this project."
      redirect_to organization_project_path(@project.organization, @project)
    end
  end
end
