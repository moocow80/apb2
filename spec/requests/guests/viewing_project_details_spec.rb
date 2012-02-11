require 'spec_helper'

describe "Viewing Project Details" do
  let(:project) { create(:project, :verified => true)  }
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
      page.should have_content(project.status.titleize)
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

    context "that havent been verified" do
      before(:each) do
        project.toggle!(:verified)
      end

      it "should not show the project on the projects page" do
        visit "/projects"
        page.should_not have_content(project.name)
      end
      it "should show a 404 error if the project is accessed via url" do
        lambda {
          visit "/organizations/#{project.organization.slug}/projects/#{project.slug}"
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
      it "should show the project to the owner" do
        request_login(project.organization.owner)
        visit "/organizations/#{project.organization.slug}/projects/#{project.slug}"
        page.should have_content(project.name)
      end
    end

    context "whose organizations havent been verified" do
      before(:each) do
        project.organization.toggle!(:verified)
      end

      it "should not show the project on the projects page" do
        visit "/projects"
        page.should_not have_content(project.name)
      end
      it "should show a 404 error if the project is accessed via url" do
        lambda {
          visit "/organizations/#{project.organization.slug}/projects/#{project.slug}"
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
      it "should show the project to the owner" do
        request_login(project.organization.owner)
        visit "/organizations/#{project.organization.slug}/projects/#{project.slug}"
        page.should have_content(project.name)
      end
    end

    context "whose organizations owner hasnt been verified" do
      before(:each) do
        project.organization.owner.toggle!(:verified)
      end

      it "should not show the project on the projects page" do
        visit "/projects"
        page.should_not have_content(project.name)
      end
      it "should show a 404 error if the project is accessed via url" do
        lambda {
          visit "/organizations/#{project.organization.slug}/projects/#{project.slug}"
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
      it "should show the project to the owner" do
        request_login(project.organization.owner)
        visit "/organizations/#{project.organization.slug}/projects/#{project.slug}"
        page.should have_content(project.name)
      end
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
end
