class UserMailer < ActionMailer::Base
  default from: "noreply@austinprobono.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_verification.subject
  #
  def email_verification(user)
    @user = user
    mail :to => user.email, :subject => "Verify your email address for AustinProBono.org"
  end

  def organization_verified(organization)
    @organization = organization
    @user = organization.owner
    mail :to => @user.email, :subject => "#{organization.name} has been verified!"
  end

  def project_verified(project)
    @project = project
    @user = project.organization.owner
    mail :to => @user.email, :subject => "#{project.name} has been verified!"
  end
  
  def notify_subscribers(project, user)
    mail :to => user.email, :subject => "We thought you might be interested in . . . "
  end
  
  def thanks_for_volunteering(contributor)
    @user = contributor.user
    @project = contributor.project
    mail :to => @user.email, :subject => "Thanks for volunteering for #{@project.name}!"
  end

  def new_project_volunteer(contributor)
    @user = contributor.user
    @project = contributor.project
    mail :to => @project.organization.owner.email, :subject => "#{@user.user_profile.name} has volunteered for #{@project.name}!"
  end

  def volunteer_status_update(contributor)
    @user = contributor.user
    @project = contributor.project
    if contributor.status == "quit"
      mail :to => @project.organization.owner.email, :subject => "#{@user.user_profile.name} has quit #{@project.name}."
    else
      mail :to => @user.email, :subject => "You have been #{contributor.status} as a volunteer for #{@project.name}."
    end
  end

  def project_updated(project)
    email_to = []
    project.contributors.each do |contributor|
      email_to << contributor.email
    end
    @project = project
    mail :to => email_to, :subject => "#{@project.name_was} has been updated."
  end
end
