require "spec_helper"

describe AdminMailer do
  describe "organization_verification" do
    let(:organization) { create(:organization) }
    let(:mail) { AdminMailer.organization_verification(organization) }

    it "renders the headers" do
      mail.subject.should eq("Please verify #{organization.name}")
      mail.to.should eq(["t.barho@gmail.com"])
      mail.from.should eq(["noreply@austinprobono.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match(organization_verify_url(organization.verification_token))
    end
  end

end
