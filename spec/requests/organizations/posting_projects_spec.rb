require 'spec_helper'

describe "Posting Projects" do
  let!(:tag1) { create(:skill_tag) }
  let!(:tag2) { create(:skill_tag) }
  let!(:tag3) { create(:cause_tag) }

  let(:project) { build(:project) }

  before(:each) do
    goto_new_project
  end

  describe "page elements" do
    it "should only show the user 'Skill' tags" do
      page.should have_content(tag1.name)
      page.should have_content(tag2.name)
      page.should_not have_content(tag3.name)
    end
  end

  describe "with valid credentials" do
    it "should create a new project" do
      lambda do
        fill_in_details_and_submit
      end.should change(Project, :count).by(1)
    end
    it "should send the user to organization details page" do
      fill_in_details_and_submit
      current_path.should eq(organization_path(project.organization))
    end
    it "should notify the user that their project was added in a flash message" do
      fill_in_details_and_submit
      page.should have_content("created")
    end
    it "should add the correct tags to the project" do
      fill_in_details_and_submit
      within "#main" do
        click_link "Projects"
      end
      page.should have_content(tag1.name)
      page.should have_content(tag2.name)
      page.should_not have_content(tag3.name)
    end
  end

  describe "with invalid credentials" do
    it "should not create a project" do
      lambda do
        fill_in_details_and_submit("A" * 500)
      end.should_not change(Project, :count)
    end
    it "should show error messages" do
      fill_in_details_and_submit("A" * 500)
      page.should have_selector("div.error_messages")
    end
    it "should send the user back to the create project page" do
      fill_in_details_and_submit("A" * 500)
      current_path.should eq("/organizations/#{project.organization.name.parameterize}/projects")
    end
  end

  def goto_new_project
    request_login(project.organization.owner)
    visit organization_path(project.organization)
    within "#main" do
      click_link "Projects"
    end
    click_link "+ Create New Project"
  end

  def fill_in_details_and_submit(name = nil)
    name ||= project.name
    fill_in "project_name", :with => name
    fill_in "project_details", :with => project.details
    fill_in "project_goals", :with => project.goals
    check tag1.name
    check tag2.name
    click_button "Create Your Project"
  end
end
