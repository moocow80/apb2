require "spec_helper"

describe UserMailer do
  describe "email_verification" do
    let(:user) { Factory(:user) }
    let(:mail) { UserMailer.email_verification(user) }

    it "renders the headers" do
      mail.subject.should eq("Verify your email address for AustinProBono.org")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@austinprobono.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match(email_verification_path(user.email_token))
    end
  end

  describe "organization_verified" do
    let(:organization) { create(:organization, :verified => true) }
    let(:mail) { UserMailer.organization_verified(organization) }

    it "renders the headers" do
      mail.subject.should eq("#{organization.name} has been verified!")
      mail.to.should eq([organization.owner.email])
      mail.from.should eq(["noreply@austinprobono.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match(organization_url(organization))
    end
    
  end

end
