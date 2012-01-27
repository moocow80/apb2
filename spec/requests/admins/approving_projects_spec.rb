require 'spec_helper'

describe "Approving Projects" do
  let(:organization) { create(:organization, :verified => true) }
  let(:project) { create(:project, :organization => organization) }
  let(:admin) { create(:admin) }

  it "should allow an admin to verify a project and notify the organization owner that it has been verified" do
    visit project_verify_path(project.verification_token)
    fill_in "Email", :with => admin.email
    fill_in "Password", :with => admin.password
    click_button "Log In"
    last_email.to.should include(organization.owner.email)
    current_path.should eq(project_verify_path(project.verification_token))
    page.should have_content("#{project.name} has been verified")
    page.should have_selector("a", :text => "View #{project.name}")
  end
  it "should not allow anyone who isnt an admin to verify the project" do
    visit project_verify_path(project.verification_token)
    fill_in "Email", :with => project.organization.owner.email
    fill_in "Password", :with => project.organization.owner.password
    click_button "Log In"
    current_path.should_not eq(project_verify_path(project.verification_token))
    page.should_not have_content("#{project.name} has been verified")
    page.should_not have_selector("a", :text => "View #{project.name}")
  end
end
