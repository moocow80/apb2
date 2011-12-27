require 'spec_helper'

describe "Create Organization" do
  let!(:tag1) { create(:cause_tag) }
  let!(:tag2) { create(:cause_tag) }
  let!(:tag3) { create(:skill_tag) }

  let(:organization) { build(:organization) }
  let(:slug) { organization.name.parameterize }

  before(:each) do
    goto_new_organization
  end

  describe "page elements" do
    it "should only show the user 'Cause' tags" do
      page.should have_content(tag1.name)
      page.should have_content(tag2.name)
      page.should_not have_content(tag3.name)
    end
  end

  describe "with valid credentials" do
    it "should create a new organization" do
      lambda do
        fill_in_details_and_submit
      end.should change(Organization, :count).by(1)
    end
    it "should send the user to the create project page" do
      fill_in_details_and_submit
      current_path.should eq(new_organization_project_path(slug))
    end
    it "should notify the user that their organization was added in a flash message" do
      fill_in_details_and_submit
      page.should have_content("created")
    end
    it "should add the correct tags to the organization" do
      fill_in_details_and_submit
      visit organization_path(slug)
      page.should have_content(tag1.name)
      page.should have_content(tag2.name)
      page.should_not have_content(tag3.name)
    end
  end

  describe "with invalid credentials" do
    it "should not create an organization" do
      lambda do
        fill_in_details_and_submit("A" * 500)
      end.should_not change(Organization, :count)
    end
    it "should show error messages" do
      fill_in_details_and_submit("A" * 500)
      page.should have_selector("div.error_messages")
    end
    it "should send the user back to the create organization page" do
      fill_in_details_and_submit("A" * 500)
      current_path.should eq("/organizations")
    end
  end

  def goto_new_organization
    request_login(organization.owner)
    visit new_organization_path
  end

  def fill_in_details_and_submit(name = nil)
    name ||= organization.name
    fill_in "organization_name", :with => name
    fill_in "organization_contact", :with => organization.contact
    fill_in "organization_contact_email", :with => organization.contact_email
    fill_in "organization_website", :with => organization.website
    fill_in "organization_phone", :with => organization.phone
    fill_in "organization_mission", :with => organization.mission
    fill_in "organization_details", :with => organization.details
    check tag1.name
    check tag2.name
    click_button "Next Step: Create a project"
  end
end
