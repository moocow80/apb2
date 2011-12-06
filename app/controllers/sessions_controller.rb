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
      
      if user.is_admin?
        redirect_back_or user
      elsif user.is_organization?
        if user.organizations.empty?
          redirect_to new_organization_path
        else
          redirect_back_or user_organizations_path(user)
        end
      elsif !user.is_organization?
        if user.user_profile.nil?
          redirect_to new_volunteer_path
        else
          redirect_back_or project_matches_path
        end
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
