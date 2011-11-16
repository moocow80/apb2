require 'spec_helper'

describe "When a  user creates an organization", :type => :request do
  let(:organization) { build(:organization) }

  before do
    Organization.destroy_all
    @count = Organization.count

    visit login_path
    fill_in "Email", :with => organization.owner.email
    fill_in "Password", :with => organization.owner.password
    click_button "Log In"
    fill_in "Name of the organization/non-profit", :with => organization.name
    fill_in "Name of the contact person", :with => organization.contact
    fill_in "Email address of the contact person", :with => organization.contact_email
    fill_in "Organization website", :with => organization.website
    fill_in "Phone number", :with => organization.phone
    fill_in "Mission statement", :with => organization.mission
    fill_in "Organization details", :with => organization.details
    click_on "Next Step: Create a project"
  end

  it "a new orgaization should be created" do
    Organization.count.should eq(@count + 1)
  end

  it "an email should be sent to admin requesting verification of the organization" do
    last_email.subject.should eq("Please verify #{organization.name}")
  end

  it "another organization with the same name cannot be created" do
    visit new_organization_path
    fill_in "Name of the organization/non-profit", :with => organization.name
    fill_in "Name of the contact person", :with => organization.contact
    fill_in "Email address of the contact person", :with => organization.contact_email
    fill_in "Organization website", :with => organization.website
    fill_in "Phone number", :with => organization.phone
    fill_in "Mission statement", :with => organization.mission
    fill_in "Organization details", :with => organization.details
    click_on "Next Step: Create a project"
    page.should have_content("already been taken")
  end

  it "the new organization should be owned by the user who created it" do
    Organization.find_by_name(organization.name).owner.should == organization.owner
  end

  it "the user should be notified that the organization was created and an email was sent for verification" do
    page.should have_content("created")
    page.should have_content("sent")
  end

  it "the organzation should not be verified" do
    Organization.find_by_name(organization.name).verified?.should eq(false)
  end

  it "the user should be directed to create a new project for the organization" do
    current_path.should eq(new_organization_project_path(organization))
  end
  


end
