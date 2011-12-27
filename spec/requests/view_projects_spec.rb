require 'spec_helper'

describe "View Projects" do
  context "for all users" do
    it "should list all of the approved projects" do
      5.times { create(:project) }
      5.times { create(:project, :verified => true) }
      visit projects_path
      page.should have_xpath("//div[@class='project']", :count => 5)
    end

    context "filtering and searching" do
      let(:skill) { create(:skill_tag) }
      let(:cause) { create(:cause_tag) }

      let(:p1) { create(:project, :verified => true) }
      let(:p2) { create(:project, :verified => true) }
      let!(:p3) { create(:project, :verified => true) }

      before(:each) do
        p1.tag_with!(skill)
        p2.organization.tag_with!(cause)
        visit projects_path
      end
      it "should allow the user to filter by skill" do
        page.should have_xpath("//div[@class='project']", :count => 3)
        check skill.name
        click_button "Apply"
        page.should have_xpath("//div[@class='project']", :count => 1)
      end
      it "should allow the user to filter by organization cause" do
        page.should have_xpath("//div[@class='project']", :count => 3)
        check cause.name
        click_button "Apply"
        page.should have_xpath("//div[@class='project']", :count => 1)
      end
      it "should allow the user to filter by skill or cause" do
        page.should have_xpath("//div[@class='project']", :count => 3)
        check cause.name
        check skill.name
        click_button "Apply"
        page.should have_xpath("//div[@class='project']", :count => 2)
      end
      it "should allow the user to search for projects by skill or cause"
    end


    it "should have a link to view the project details" do
      project = create(:project, :verified => true)
      visit projects_path
      page.should have_selector("a", :text => project.name)
    end
    it "should show the organization assoicated to the listed project" do
      project = create(:project, :verified => true)
      visit projects_path
      page.should have_content(project.organization.name)
    end

    it "should provide a link to view the project details" do
      organization = create(:organization, :verified => true)
      2.times { create(:project, :organization => organization, :verified => true) }
      visit projects_path
      organization.projects.each do |project|
        page.should have_content(project.name)
        page.should have_selector("a", :href => organization_project_path(organization, project))
      end
    end

    it "should have a pagination interface" do
      51.times { create(:project, :verified => true) }
      visit projects_path
      click_link "2"
      page.should have_selector("em", :text => "2")
      page.should have_selector("a", :text => "Previous")
      page.should have_selector("a", :text => "1")
      page.should have_selector("a", :text => "3")
      page.should have_selector("a", :text => "Next")
    end

    it "should paginate the projects at 20 per page" do
      51.times { create(:project, :verified => true) }
      visit projects_path
      click_link "20"
      page.should have_xpath("//div[@class='project']", :count => 20)
    end

    it "should paginate the projects at 50 per page" do
      51.times { create(:project, :verified => true) }
      visit projects_path
      click_link "50"
      page.should have_xpath("//div[@class='project']", :count => 50)
    end

    it "should allow the user to view all of the projects at once" do
      51.times { create(:project, :verified => true) }
      visit projects_path
      click_link "All"
      page.should have_xpath("//div[@class='project']", :count => 51)
    end
  end
end
