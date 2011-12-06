class UsersController < ApplicationController
  def index
  end

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Congratulations, your account was created! Check your inbox and click the link to verify your email address."
      if @user.type == "organization"
        @user.toggle!(:is_organization)
        redirect_to new_organization_path
      else
        redirect_to new_volunteer_path
      end
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
    user = User.find_by_email_token(params[:id])
    if user
      user.toggle!(:verified)
      flash[:success] = "Congratulations, your email address has been verified!"
      if !user.user_profiles.empty?
        redirect_to project_matches_path(user)
      else
        redirect_to new_volunteer_path
      end
    else
      flash[:error] = "Sorry, we couldn't find that email address in our system"
      redirect_to login_path
    end
  end
end
