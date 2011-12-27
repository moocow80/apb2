require 'spec_helper'

describe NewsletterSubscriber do
  before(:each) do
    @subscriber = NewsletterSubscriber.new(:email => "sample@example.com")
  end
  it "should be valid with valid attributes" do
    @subscriber.should be_valid
  end
  it "should require an email address" do
    @subscriber.email = nil
    @subscriber.should_not be_valid
  end
end
