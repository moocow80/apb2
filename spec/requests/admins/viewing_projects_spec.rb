require 'spec_helper'

describe "Viewing Projects" do
  context "as an admin" do
    let(:admin) { create(:admin) }

    before(:each) do
      request_login(admin)
      click_link "Projects"
    end

    it "should list all of the projects" do
      5.times { create(:project) }
      5.times { create(:project, :verified => true) }
      click_link "Projects"
      Project.all.each do |project|
        page.should have_content(project.name)
      end
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
    end
  end
end
