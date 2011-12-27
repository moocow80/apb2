class NewsletterSubscriberMailer < ActionMailer::Base
  default from: "noreply@austinprobono.org"

  def newsletter_subscription_confirmation(newsletter_subscriber)
    @newsletter_subscriber = newsletter_subscriber
    mail(:to => newsletter_subscriber.email, :subject => "Thanks for subscribing to the AustinProBono Newsletter!")
  end
end

