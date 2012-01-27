require 'spec_helper'

describe "Editing User Profiles" do

  context "as a volunteer" do
    let(:user_profile) { create(:user_profile) }
    let(:new_profile) { build(:user_profile) }

    let(:user) { user_profile.user }

    let!(:skill1) { create(:skill_tag) }
    let!(:skill2) { create(:skill_tag) }
    let!(:cause1) { create(:cause_tag) }
    let!(:cause2) { create(:cause_tag) }

    before(:each) do
      user_profile.tag_with!(skill1)
      user_profile.tag_with!(cause1)

      request_login(user)
      click_link "My Profile"
    end

    it "should have the URL /profile" do
      current_path.should eq "/profile"
    end
    it "should have an Edit button (link)" do
      page.should have_selector("a", :text => "Edit")
    end

    context "with valid credentials" do
      before(:each) do
        click_link "Edit"
        fill_in "Name", :with => new_profile.name
        fill_in "Phone", :with => new_profile.phone
        fill_in "Current Employer", :with => new_profile.current_employer
        fill_in "Job Title", :with => new_profile.job_title
        fill_in "Degrees", :with => new_profile.degrees
        fill_in "Experience", :with => new_profile.experience
        fill_in "Website", :with => new_profile.website
        uncheck skill1.name.titleize
        uncheck cause1.name.titleize
        check skill2.name.titleize
        check cause2.name.titleize
        click_button "Save"
      end

      it "should notify the user that they have updated their profile" do
        page.should have_content "Your profile has been successfully updated!"
      end
      it "should send them back to their user profile" do
        current_path.should eq "/profile"
      end
      it "should display the updated information on the users profile page" do
        page.should have_content(new_profile.name)
        page.should have_content(new_profile.phone)
        page.should have_content(new_profile.current_employer)
        page.should have_content(new_profile.job_title)
        page.should have_content(new_profile.degrees)
        page.should have_content(new_profile.experience)
        page.should have_content(new_profile.website)
      end
      it "should show the updated tags on the user profile page" do
        page.should have_content(skill2.name)
        page.should have_content(cause2.name)
      end
    end

    context "with invalid credentials" do
      before(:each) do
        click_link "Edit"
        fill_in "Name", :with => ""
        click_button "Save"
      end

      it "should show the user error messages" do
        page.should have_selector(".error_messages")
      end
      it "should not change the user profile information" do
        visit "/profile"
        page.should have_content(user_profile.name)
        page.should have_content(user_profile.phone)
        page.should have_content(user_profile.current_employer)
        page.should have_content(user_profile.job_title)
        page.should have_content(user_profile.degrees)
        page.should have_content(user_profile.experience)
        page.should have_content(user_profile.website)
      end
    end

    
  end


end
