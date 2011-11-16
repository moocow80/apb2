require 'spec_helper'

describe "Organization Verifications" do
  let(:organization) { create(:organization) }
  let(:admin) { create(:admin) }

  it "should allow an admin to verify an organization and notify the organization that it has been verified" do
    visit organization_verify_path(organization.verification_token)
    fill_in "Email", :with => admin.email
    fill_in "Password", :with => admin.password
    click_button "Log In"
    last_email.to.should include(organization.owner.email)
    current_path.should eq(organization_verify_path(organization.verification_token))
    page.should have_content("#{organization.name} has been verified")
    page.should have_selector("a", :text => "View #{organization.name}")
  end
  it "should no allow anyone who isnt an admin to verify the organization" do
    visit organization_verify_path(organization.verification_token)
    fill_in "Email", :with => organization.owner.email
    fill_in "Password", :with => organization.owner.password
    click_button "Log In"
    current_path.should_not eq(organization_verify_path(organization.verification_token))
    page.should_not have_content("#{organization.name} has been verified")
    page.should_not have_selector("a", :text => "View #{organization.name}")
  end
end
