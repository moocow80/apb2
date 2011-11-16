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
end
