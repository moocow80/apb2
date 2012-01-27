require 'spec_helper'

describe "Newsletter Signups" do
  let(:newsletter_subscriber) { build(:newsletter_subscriber) }

  it "a new subscriber should be created" do
    lambda do
      subscribe_to_newsletter(newsletter_subscriber.email)
    end.should change(NewsletterSubscriber, :count).by(1)
  end
  it "should send an email that informs the subscriber that they have now subscribed to the newsletter" do
    subscribe_to_newsletter(newsletter_subscriber.email)
    last_email.subject.should eq("Thanks for subscribing to the AustinProBono Newsletter!")
  end
  it "should display a message that shows the subscriber that they have successfully subscribed to the newsletter" do
    subscribe_to_newsletter(newsletter_subscriber.email)
    page.should have_content("successfully")
  end

  def subscribe_to_newsletter(email)
    visit home_path
    fill_in "email", :with => email
    click_button "Submit"
  end
end
