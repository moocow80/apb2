require 'spec_helper'

describe "Viewing Project Details" do
  let(:project) { create(:project)  }
  let(:skill1) { create(:skill_tag) }
  let(:skill2) { create(:skill_tag) }

  before(:each) do
    project.tag_with!(skill1)
    project.tag_with!(skill2)
  end

  context "as a guest" do
    before(:each) do
      visit organization_project_path(project.organization, project)
    end
    it "should show the project details" do
      page.should have_content(project.name)
      page.should have_content(project.details)
      page.should have_content(project.goals)
      page.should have_content(project.status)
    end
    it "should show the project tags" do
      page.should have_content skill1.name 
      page.should have_content skill2.name 
    end
    it "should show an apply link" do
      page.should have_selector("a", :text => "Volunteer for this Project")
    end
    it "should show the organization" do
      page.should have_content(project.organization.name)
    end
    it "should not show editing links" do
      page.should_not have_selector("a", :text => "Edit Project")
    end

    context "who clicks 'Apply'" do
      before(:each) do
        click_link "Volunteer for this Project"
      end
      it "should direct them to the register page" do
        current_path.should eq register_path
      end
    end
  end

  context "as a volunteer" do
    let(:volunteer) { create(:volunteer, :verified => true) }

    before(:each) do
      Contributor.destroy_all
      request_login(volunteer)
      visit organization_project_path(project.organization, project)
    end
    context "who clicks 'Apply'" do
      before(:each) do
        click_link "Volunteer for this Project"
      end
      it "should apply for the project"
    end
  end

  context "as an organization" do
    before(:each) do
      request_login(project.organization.owner)
      visit organization_project_path(project.organization, project)
    end
    it "should show editing links" do
      page.should have_selector("a", :text => "Edit Project")
    end
  end
end
