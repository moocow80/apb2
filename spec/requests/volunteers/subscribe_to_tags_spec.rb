require 'spec_helper'

describe "Subscribing to Tags" do
  let!(:skill_tag) { create(:skill_tag) }
  let!(:cause_tag) { create(:cause_tag) }

  context "as a volunteer" do
    let!(:user) { create(:user, :verified => true) }
    let!(:user_profile) { create(:user_profile, :user => user) }
    let!(:organization) { create(:organization, :verified => true) }
    let(:project) { build(:project) }

    before(:each) do
      user_profile.tag_with!(skill_tag)
      user_profile.tag_with!(cause_tag)
      goto_new_project
      fill_in_details_and_submit
    end

    it "should receive email when a new project is now online with matching tags of theirs." do
      last_email.to.should eq [user.email]
      last_email.subject.should eq "We thought you might be interested in . . . "
    end
  end
  
  def goto_new_project
    request_login(organization.owner)
    visit organization_path(organization)
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
    check skill_tag.name
    click_button "Create Your Project"
  end
end
