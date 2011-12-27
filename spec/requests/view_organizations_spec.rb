require 'spec_helper'

describe "View Organizations" do
  context "for all users" do
    it "should list all of the approved organizations" do
      5.times { create(:organization) }
      5.times { create(:organization, :verified => true) }
      visit organizations_path
      page.should have_xpath("//div[@class='project']", :count => 5)
    end
    context "filtering and searching" do
      let(:cause) { create(:cause_tag) }
      let(:skill) { create(:skill_tag) }
      
      let(:o1)  { create(:organization, :verified => true) }
      let(:o2)  { create(:organization, :verified => true) }
      let(:o3)  { create(:organization, :verified => true) }
      let!(:o4) { create(:organization, :verified => true) }
      let(:p1)  { create(:project, :organization => o1, :verified => true) }
      let(:p2)  { create(:project, :organization => o2, :verified => true) }
      let(:p3)  { create(:project, :organization => o3, :verified => true) }

      before(:each) do
        o1.tag_with!(cause)
        p2.tag_with!(skill)
        o3.tag_with!(cause)
        p3.tag_with!(skill)
        visit organizations_path
      end
      it "should allow the user to filter by organization cause" do
        page.should have_xpath("//div[@class='project']", :count => 4)
        check cause.name
        click_button "Apply"
        page.should have_xpath("//div[@class='project']", :count => 2)
      end
      it "should allow the user to filter by skill" do
        page.should have_xpath("//div[@class='project']", :count => 4)
        check skill.name
        click_button "Apply"
        page.should have_xpath("//div[@class='project']", :count => 2)
      end
      it "should allow the user to filter by skill or cause" do
        page.should have_xpath("//div[@class='project']", :count => 4)
        check cause.name
        check skill.name
        click_button "Apply"
        page.should have_xpath("//div[@class='project']", :count => 3)
      end
      it "should allow the user to search for organization by skill or cause"

    end
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
    it "should paginate the organizations at 20 per page" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "20"
      page.should have_xpath("//div[@class='project']", :count => 20)
    end
    it "should paginate the organizations at 50 per page" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "50"
      page.should have_xpath("//div[@class='project']", :count => 50)
    end
    it "should allow the user to view all of the organizations at once" do
      51.times { create(:organization, :verified => true) }
      visit organizations_path
      click_link "All"
      page.should have_xpath("//div[@class='project']", :count => 51)
    end
  end
end
