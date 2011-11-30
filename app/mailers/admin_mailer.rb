class AdminMailer < ActionMailer::Base
  default from: "noreply@austinprobono.org"
  default to: "t.barho@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.organization_verification.subject
  #
  def organization_verification(organization)
    @organization = organization
    mail subject: "Please verify #{organization.name}"
  end

  def project_verification(project)
    @project = project
    mail subject: "Please verify #{project.name}"
  end
end
