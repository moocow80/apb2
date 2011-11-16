require 'spec_helper'

describe OrganizationObserver do
  
  describe "after_create" do
    it "emails an admin asking them to verify the organization" do
      organization = build(:organization)
      organization.save
      last_email.subject.should eq("Please verify #{organization.name}")
    end
  end

  describe "after_verified" do
    it "should send an email to an organization owner if their organization has been verified" do
      organization = create(:organization)
      reset_email
      organization.toggle!(:verified)
      last_email.to.should include(organization.owner.email)
    end
    it "should not send an email when an owner edits a verified organization" do
      organization = create(:organization, :verified => true)
      reset_email
      organization.name = "Some New Name"
      last_email.should be_nil
    end
  end

end
