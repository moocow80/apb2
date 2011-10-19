class UserProfilesController < ApplicationController
  before_filter :authenticate, :except => [:show]
  def index
  end

  def show
  end

  def new
    @user_profile = current_user.user_profiles.new
    @tags = Tag.where(:tag_type => "category")
  end

  def create
    @user_profile = current_user.user_profiles.create(params[:user_profile])
    if @user_profile.save
      flash[:success] = "Your profile was created!"
      redirect_to root_path
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

end
