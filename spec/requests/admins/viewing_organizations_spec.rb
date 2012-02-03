require 'spec_helper'

describe "Viewing Organizations" do
  let(:admin) { create(:admin) }

  before(:each) do
    request_login(admin)
    click_link "Organizations"
  end
  context "as an admin" do
    it "should list all of the approved organizations" do
      5.times { create(:organization) }
      5.times { create(:organization, :verified => true) }
      click_link "Organizations"
      page.should have_xpath("//div[@class='project']", :count => 10)
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
  end
end
