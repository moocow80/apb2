class UserProfilesController < ApplicationController
  before_filter :authenticate, :except => [:show]
  def index
  end

  def show
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
    @user_profile = UserProfile.find(params[:id])
  end

  def update
    @user_profile = UserProfile.find(params[:id])
    if @user_profile.update_attributes(params[:user_profile])
      flash[:success] = "Your profile was update"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
  end

end
