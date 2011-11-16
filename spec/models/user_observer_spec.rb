require 'spec_helper'

describe UserObserver do

  describe "after_create" do

    it "emails a user asking them to verify their email account" do
      user = User.create(:email => "test@example.com", :password => "secret", :password_confirmation => "secret", :type => "volunteer")
      last_email.to.should include(user.email)
    end
  end

end
