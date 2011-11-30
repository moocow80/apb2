require 'spec_helper'

describe "When a user creates a new project" do
  let(:organization) { Factory(:organization) }
  let(:project) { organization.projects.build(
    :name => "Sample Project", 
    :details => "Sample details", 
    :goals => "Sample deliverables") } 

  before do
    @tag1 = Tag.create(:name => "Accounting", :tag_type => "category")
    @tag2 = Tag.create(:name => "web design", :tag_type => "category")
    @tag3 = Tag.create(:name => "public Relations", :tag_type => "category")
    @tag4 = Tag.create(:name => "Customer service", :tag_type => "category")
  
    user = organization.owner

    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log In"
    visit organization_path(organization)
    click_link "New Project"
    fill_in "project_name", :with => project.name 
    fill_in "Details", :with => project.details 
    fill_in "Goals", :with => project.goals 
  end

  context "with valid information" do
    before do
      check "Accounting"
      check "Web Design"
      check "Customer Service"
    end
    it "a new project is created for that organization" do
      lambda do
        click_button "Create Your Project"
      end.should change(organization.projects, :count).by(1)
    end
    it "the appropriate tags are added to the project" do
      click_button "Create Your Project"
      new_project = Project.find_by_organization_id_and_name(organization.id, project.name)
      new_project.tags.should_not eq([])
    end
    it "the user is sent to the organization detail page" do
      click_button "Create Your Project"
      current_path.should eq(organization_path(organization))
    end
    it "the user is notified that their project was added" do
      click_button "Create Your Project"
      page.should have_content("created")
    end
  end

  context "with invalid information" do
    before do
      fill_in "project_name", :with => ""
    end
    it "a project is not created" do
      lambda do
        click_button "Create Your Project"
      end.should_not change(Project, :count)
    end
    it "the page show error messages" do
      click_button "Create Your Project"
      page.should have_xpath("//div", :class => "error_messages")
    end
    it "the user is sent back to the project creation page" do
      click_button "Create Your Project"
      current_path.should eq("/#{organization.name.parameterize}/projects")
    end
  end

end
