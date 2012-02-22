require 'spec_helper'

describe "Viewing Project Matches" do
  let(:user) { create(:volunteer, :verified => true) }
  let!(:user_profile) { create(:user_profile, :user => user) }
  let!(:matching_project) { create(:project, :verified => true) }
  let!(:unmatching_project) { create(:project, :verified => true) }
  let!(:cause_tag) { create(:cause_tag) }
  let!(:skill_tag) { create(:skill_tag) }

  before(:each) do
    user_profile.tag_with!(cause_tag)
    user_profile.tag_with!(skill_tag)

    matching_project.organization.tag_with!(cause_tag)
    matching_project.tag_with!(skill_tag)
  end

  context "as a new-ish volunteer" do
    before(:each) do
      request_login(user)
    end
    
    it "should direct the user to their matches on login" do
      page.should have_content("Your Matches")
    end
    it "should show the matching projects" do
      page.should have_content(matching_project.name)
    end
    it "should not show the projects that don't match" do
      page.should_not have_content(unmatching_project.name)
    end
    it "should show the tags that were matched next to the project" do
      page.should have_content(cause_tag.name)
      page.should have_content(skill_tag.name)
    end
  end
end
