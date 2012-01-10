class ContributorsController < ApplicationController
  def create
    if current_user.nil?
      flash[:error] = "You must be logged in to apply for a project"
      return redirect_to login_path
    end

    project = Project.find_by_slug(params[:project_id])

    if project.nil?
      flash[:error] = "Sorry, the project could not be found."
      return redirect_back_or root_path
    end

    contributor = project.contributions.new(:user_id => current_user.id)

    if contributor.save
      flash[:success] = "Congratulations, you have successfully volunteered for #{project.name}"
    else
      flash[:error] = "Sorry, there was a problem volunteering you for this project."
    end
    redirect_to organization_project_path(project.organization, project)
  end

  def edit
  end

  def update
  end

end
