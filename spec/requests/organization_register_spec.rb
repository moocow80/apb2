require 'spec_helper'

describe "When a  user creates an organization", :type => :request do
  let(:user) { Factory(:user, :is_organization => true, :type => "organization") }
  let(:organization) { user.organizations.build(
    :name => "Sample Organization",
    :contact => "Test Person",
    :contact_email => "test@example.com",
    :website => "http://google.com",
    :phone => "555-555-5555",
    :mission => "We are on a mission",
    :details => "These are some details"
  ) }

  before do
    Organization.destroy_all
    @count = Organization.count

    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
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
    Organization.find_by_name("Sample Organization").owner.should == user
  end

  it "the new organization should have the right details" do
    @organization = user.organizations.find_by_name(organization.name)
    visit organization_path(@organization)
    page.should have_content(organization.name)
    page.should have_content(organization.contact)
    page.should have_content(organization.contact_email)
    page.should have_content(organization.website)
    page.should have_content(organization.phone)
    page.should have_content(organization.mission)
    page.should have_content(organization.details)
  end

  it "the user should be notified that the organization was created" do
    page.should have_content("created")
  end

  it "the user should be directed to create a new project for the organization" do
    current_path.should eq("/sample-organization/projects/new")
  end
  


end
