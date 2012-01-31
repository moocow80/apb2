class UserProfilesController < ApplicationController
  before_filter :authenticate
  def index
  end

  def show
    @user_profile = current_user.user_profile
  end

  def new
    @user_profile = current_user.build_user_profile
    @tags = Tag.where(:tag_type => "category")
  end

  def create
    @user_profile = current_user.create_user_profile(params[:user_profile])
    if @user_profile.save
      flash[:success] = "Your profile was created!"
      if current_user.verified?
        redirect_to project_matches_path
      else
        redirect_to user_path(current_user) 
      end
    else
      render 'new'
    end
  end

  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile
    if @user_profile.update_attributes(params[:user_profile])
      flash[:success] = "Your profile has been successfully updated!"
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  def projects
    @contributors = Contributor.where("user_id", current_user.id).includes(:project)
  end

end
