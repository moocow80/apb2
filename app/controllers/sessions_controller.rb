class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email / password combination"
      render 'new'
    else
      sign_in user
      if user.is_organization?
        redirect_to organizations_path
      elsif user.user_profiles.nil?
        redirect_to new_volunteer_path
      else
        redirect_to user
      end
    end


  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
