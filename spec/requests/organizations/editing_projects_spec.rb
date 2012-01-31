require 'spec_helper'

describe "Editing Projects" do
  context "as an organization" do
    let!(:organization) { create(:organization, :verified => true) }
    let!(:project) { create(:project, :verified => true, :organization => organization) }
    let!(:new_skill) { create(:skill_tag) }
    let!(:contributor) { create(:volunteer, :verified => true) }
    let!(:user_profile) { create(:user_profile, :user => contributor) }
    let!(:contribution) { create(:contributor, :user => contributor, :project => project) }

    before(:each) do
      request_login(organization.owner)
      click_link "My Organizations"
      click_link organization.name
      within "#main" do
        click_link "Projects"
      end
      click_link project.name
      click_link "Edit Project"
    end

    it "should show the organization an edit form" do
      page.should have_selector("form", :id => "edit_project_#{project.id}")
    end

    it "should not allow users who don't own the project to edit it" do
      new_org = create(:organization, :verified => true)
      bad_user = new_org.owner

      click_link "Log Out"
      request_login(bad_user)
      visit edit_organization_project_path(organization, project)

      page.should have_content "You are not authorized to edit this project."
      page.should_not have_selector("form", :id => "edit_project_#{project.id}")
    end

    context "with valid credentials" do
      let(:new_project) { build(:project) }

      before(:each) do
        check new_skill.name
        fill_in "Name", :with => new_project.name
        fill_in "Details", :with => new_project.details
        fill_in "Goals", :with => new_project.goals
        select "In Progress", :from => "Status"
        click_button "Update Project"
      end
      it "should allow the organization to edit the project" do
        page.should have_content(new_skill.name)
        page.should have_content(new_project.name)
        page.should have_content(new_project.details)
        page.should have_content(new_project.goals)
        page.should have_content("In Progress")
      end
      it "should inform the organization that the project has been updated" do
        page.should have_content("Your project was successfully updated!")
      end
      it "should notify project applicants of the updates via email" do
        last_email.to.should eq [contributor.email]
        last_email.subject.should eq "#{project.name} has been updated."
      end
      it "should redirect to the project details" do
        current_path.should eq organization_project_path(organization, new_project.name.parameterize)
      end
    end

    context "with invalid credentials" do
      before(:each) do
        fill_in "Name", :with => ""
        click_button "Update Project"
      end
      it "should show the organization the errors" do
        page.should have_selector(".error_messages")
      end
    end
  end
end
