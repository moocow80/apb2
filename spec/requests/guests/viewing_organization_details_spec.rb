require 'spec_helper'

describe "Viewing Organization Details" do
  let(:project) { Factory(:project) }
  let(:organization) { project.organization }

  context "as a visitor" do
    before(:each) do
      visit organization_path(organization)    
    end
    it "should show the organizations details" do
      page.should have_content(organization.name) 
      page.should have_content(organization.contact) 
      page.should have_content(organization.contact_email) 
      page.should have_content(organization.website) 
      page.should have_content(organization.phone) 
      page.should have_content(organization.mission) 
      page.should have_content(organization.details) 
    end
    it "should show the organizations projects" do
      page.should have_content(project.name)
    end
    it "should not show a new project link" do
      page.should_not have_selector("a[href=\"#{new_organization_project_path(organization)}\"]")
    end
    it "should not show project editing links" do
      page.should_not have_selector("a[href=\"#{edit_organization_project_path(organization, project)}\"]")
    end
  end

  context "as a volunteer" do
    before(:each) do
      @volunteer = Factory(:user)
      visit login_path
      fill_in "Email", :with => @volunteer.email
      fill_in "Password", :with => @volunteer.password
      click_button "Log In"
      visit organization_path(organization)    
    end
    it "should not show a new project link" do
      page.should_not have_selector("a[href=\"#{new_organization_project_path(organization)}\"]")
    end
    it "should not show project editing links" do
      page.should_not have_selector("a[href=\"#{edit_organization_project_path(organization, project)}\"]")
    end
  end
  
  context "as the organization owner" do
    before(:each) do
      @owner = organization.owner
      visit login_path
      fill_in "Email", :with => @owner.email
      fill_in "Password", :with => @owner.password
      click_button "Log In"
      visit organization_path(organization)    
    end
    it "should show a new project link" do
      page.should have_selector("a[href=\"#{new_organization_project_path(organization)}\"]")
    end
    it "should show project editing links" do
      page.should have_selector("a[href=\"#{edit_organization_project_path(organization, project)}\"]")
    end
  end

end
