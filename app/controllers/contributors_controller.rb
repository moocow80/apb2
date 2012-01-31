class ContributorsController < ApplicationController
  before_filter :authenticate

  def create
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
    @project = Project.find_by_slug(params[:project_id])
    @contributor = Contributor.find(params[:id], :include => [:user, :project])
    if @contributor.update_attributes(params[:contributor])
      if @contributor.status == "quit"
        flash[:success] = "You have successfully quit #{@project.name}."
      else
        flash[:success] = "#{@contributor.user.user_profile.name} was #{@contributor.status} as a volunteer."
      end
    else
      flash[:error] = "#{@contributor.errors.full_messages.join(".  ")}"
    end
    redirect_to organization_project_path(@contributor.project.organization, @contributor.project)
  end

end
