require 'spec_helper'

describe "When a user creates their profile" do
  let(:user) { Factory(:user, :is_organization => false, :type => "volunteer") }
  let(:user_profile) { user.user_profiles.build(:name => "Test User", :description => "This is a great description of me.", :website => "http://www.google.com") }

  before do
    @tag1 = Tag.create(:name => "Accounting", :tag_type => "category")
    @tag2 = Tag.create(:name => "web design", :tag_type => "category")
    @tag3 = Tag.create(:name => "public Relations", :tag_type => "category")
    @tag4 = Tag.create(:name => "Customer service", :tag_type => "category")

    @count = UserProfile.count
    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log In"
    visit new_volunteer_path
    fill_in "Name", :with => user_profile.name
    fill_in "Description", :with => user_profile.description
    fill_in "Website", :with => user_profile.website
  end

  context "with valid information" do
    before do
      check "Accounting"
      check "Web Design"
      check "Customer Service"
      choose "user_profile_available_1"
      click_button "Next Step: Match me up with a project"
    end
    it "a new user profile is created for that user" do
      UserProfile.count.should eq(@count + 1)
      UserProfile.find_by_user_id(user.id).should_not be_nil
    end
    it "the appropriate tags are added to the user" do
      profile = UserProfile.find_by_user_id(user.id)
      profile.tags.should_not eq([])
    end
    it "the user is sent to the project matches page" do
      current_path.should eq(project_matches_path)
    end
    it "the user is notified that their profile was added" do
      page.should have_xpath("//div", :id => "flash_notice", :content => "added")
    end
  end

  context "with invalid information" do
    before do
      fill_in "user_profile_name", :with => ""
      click_button "Next"
    end
    it "the page show error messages" do
      page.should have_xpath("//div", :class => "error_messages")
    end
    it "the user is sent back to the user profile creation page" do
      current_path.should eq("/user_profiles")
    end
    it "a user profile is not created" do
      UserProfile.count.should eq(@count)
    end

  end
end
