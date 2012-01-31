require 'spec_helper'

describe "Viewing Projects with Status" do
  context "as an organization" do
    let!(:organization) { create(:organization, :verified => true) }
    let!(:pending) { create(:project, :verified => true, :organization => organization, :status => "pending") }
    let!(:open) { create(:project, :verified => true, :organization => organization, :status => "open") }
    let!(:in_progress) { create(:project, :verified => true, :organization => organization, :status => "in_progress") }
    let!(:completed) { create(:project, :verified => true, :organization => organization, :status => "completed") }
    let!(:cancelled) { create(:project, :verified => true, :organization => organization, :status => "cancelled") }

    before(:each) do
      request_login(organization.owner)
      click_link "My Organizations"
      click_link organization.name
      within "#main" do
        click_link "Projects"
      end
    end
    it "should show a list of the organizations projects" do
      page.should have_selector(".project", :count => 5)
    end
    it "should show edit links for each project" do
      page.should have_selector("a", :text => "Edit Project", :count => 5)
    end
    it "should show the status of each project" do
      page.should have_content("Pending")
      page.should have_content("Open")
      page.should have_content("In Progress")
      page.should have_content("Completed")
      page.should have_content("Cancelled")
    end
  end
end
