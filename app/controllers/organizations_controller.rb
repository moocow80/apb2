class OrganizationsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show, :showall]
  before_filter :is_admin, :only => [:verify]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
  before_filter :is_verified, :only => [:show]

  def index
    per_page = params[:per_page] || 20
    if params[:cause_tag_ids] && params[:skill_tag_ids]
      sql = Organization.verified.with_causes_and_skills_sql(params[:cause_tag_ids].join(","), params[:skill_tag_ids].join(","))
    elsif params[:cause_tag_ids]
      sql = Organization.verified.with_causes(params[:cause_tag_ids].join(",")).to_sql
    elsif params[:skill_tag_ids]
      sql = Organization.verified.with_skills_sql(params[:skill_tag_ids].join(","))
    elsif params[:search]
      sql = Organization.search(params[:search])
    else
      sql = Organization.verified.to_sql
    end
    @organizations = Organization.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
  end

  def show
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
    if @organization.update_attributes(params[:organization])
      flash[:success] = "Your organization has been successfully updated!"
      redirect_to @organization
    else
      render :edit
    end
  end

  def destroy
  end

  def showall
   # @users = User.paginate(:page => params[:page], :per_page => 10 )
    @organizations = Organization.paginate(:page => params[:page], :per_page => 10)
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

  def correct_user
    @organization = Organization.find_by_slug(params[:id])
    if @organization.owner != current_user
      flash[:error] = "You don't have permission to access this organization."
      redirect_back_or @organization
    end
  end

  def is_verified
    @organization = Organization.find_by_slug(params[:id])
    unless current_user == @organization.owner
      not_found unless @organization.verified? && @organization.owner.verified?
    end
  end

end
