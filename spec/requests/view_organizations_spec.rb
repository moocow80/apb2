require 'spec_helper'

describe "View Organizations" do
  context "for all users" do
    it "should list all of the approved organizations" do
      5.times { create(:organization) }
      5.times { create(:organization, :verified => true) }
      visit organizations_path
      page.should have_xpath("//div[@class='organization']", :count => 5)
    end

    it "should allow the user to filter by cause" 
    it "should allow the user to filter by project type"
    it "should allow the user to search for organizations by type or cause"

    it "should have a link to view the organization details" do
      organization = create(:organization, :verified => true)
      visit organizations_path
      page.should have_selector("a", :text => organization.name)
    end
    it "should show how many projects are available for each organization" do
      organization = create(:organization, :verified => true)
      2.times { create(:project, :organization => organization, :verified => true) }
      visit organizations_path
      page.should have_selector("a", :text => "#{organization.projects.count} available projects")
    end
    it "should list the projects for each organization with a link to view the project details" do
      organization = create(:organization, :verified => true)
      2.times { create(:project, :organization => organization, :verified => true) }
      visit organizations_path
      organization.projects.each do |project|
        page.should have_content(project.name)
        page.should have_selector("a", :href => organization_project_path(organization, project))
      end
    end
    it "should have a pagination interface" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "2"
      page.should have_selector("em", :text => "2")
      page.should have_selector("a", :text => "Previous")
      page.should have_selector("a", :text => "1")
      page.should have_selector("a", :text => "3")
      page.should have_selector("a", :text => "Next")
    end
    it "should paginate the projects at 20 per page" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "20"
      page.should have_selector(".organization .title", :count => 20)
    end
    it "should allow the user to view all of the organizations at once" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "50"
      page.should have_selector(".organization .title", :count => 50)
    end
    it "should allow the user to view all of the organizations at once" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "All"
      page.should have_selector(".organization .title", :count => 51)
    end
  end
end
