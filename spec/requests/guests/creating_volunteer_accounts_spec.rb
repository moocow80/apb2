require 'spec_helper'

describe "Creating Volunteer Accounts" do
  let!(:tag1) { create(:cause_tag) }
  let!(:tag2) { create(:cause_tag) }
  let!(:tag3) { create(:skill_tag) }
  let!(:tag4) { create(:skill_tag) }
  let!(:tag5) { create(:tag) }

  let(:user_profile) { build(:user_profile) }

  before(:each) do
    goto_new_user_profile
  end

  describe "page elements" do
    it "should only show the user 'Cause' and 'Skill' tags" do
      page.should have_content(tag1.name)
      page.should have_content(tag2.name)
      page.should have_content(tag3.name)
      page.should have_content(tag4.name)
      page.should_not have_content(tag5.name)
    end
  end

  describe "with valid credentials" do
    it "should create a new user_profile" do
      lambda do
        fill_in_details_and_submit
      end.should change(UserProfile, :count).by(1)
    end
    it "should send the user to the project matches page" do
      user_profile.user.toggle!(:verified)
      fill_in_details_and_submit
      current_path.should eq(project_matches_path)
    end
    it "should notify the user that their user_profile was added in a flash message" do
      fill_in_details_and_submit
      page.should have_content("created")
    end
    it "should add the correct tags to the user_profile" do
      user_profile.user.toggle!(:verified)
      fill_in_details_and_submit
      visit user_path(user_profile.user)
      page.should have_content(tag1.name)
      page.should have_content(tag2.name)
      page.should have_content(tag3.name)
      page.should have_content(tag4.name)
      page.should_not have_content(tag5.name)
    end
  end

  describe "with invalid credentials" do
    it "should not create an user_profile" do
      lambda do
        fill_in_details_and_submit("A" * 500)
      end.should_not change(UserProfile, :count)
    end
    it "should show error messages" do
      fill_in_details_and_submit("A" * 500)
      page.should have_selector("div.error_messages")
    end
    it "should send the user back to the create user_profile page" do
      fill_in_details_and_submit("A" * 500)
      current_path.should eq("/user_profiles")
    end
  end

  def goto_new_user_profile
    request_login(user_profile.user)
    visit new_volunteer_path
  end

  def fill_in_details_and_submit(name = nil)
    name ||= user_profile.name
    fill_in "user_profile_name", :with => name
    fill_in "user_profile_phone", :with => user_profile.phone
    fill_in "user_profile_current_employer", :with => user_profile.current_employer
    fill_in "user_profile_job_title", :with => user_profile.job_title
    fill_in "user_profile_degrees", :with => user_profile.degrees
    fill_in "user_profile_experience", :with => user_profile.experience
    fill_in "user_profile_website", :with => user_profile.website
    choose "user_profile_available_1"
    check tag1.name
    check tag2.name
    check tag3.name
    check tag4.name
    click_button "Next Step: Match me up with a project"
  end
end
