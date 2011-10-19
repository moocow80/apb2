class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Congratulations, your account was created!"
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
end
