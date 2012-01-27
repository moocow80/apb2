require 'spec_helper'

describe "Signing In" do
  let(:user) { create(:user) }

  it "should sign the user in if they have good credentials" do
    request_login(user)
    page.should have_content("Log Out")
  end
  it "should not sign the user in if they have bad credentials" do
    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "wrongpassword"
    click_button "Log In"
    page.should_not have_content("Log Out")
    page.should have_content("Invalid")
    current_path.should eq("/sessions")
  end

  context "redirects" do

    context "for organizations" do
      let(:owner) { create(:owner) }
      let(:organization) { create(:organization) }

      it "should redirect them to create an organization if they dont have one" do
        request_login(owner)
        current_path.should eq(new_organization_path)
      end
      it "should redirect them to the page they requested, or their organizations index page if they werent requesting another page" do
        visit edit_organization_path(organization)
        fill_in "Email", :with => organization.owner.email
        fill_in "Password", :with => organization.owner.password
        click_button "Log In"
        current_path.should eq(edit_organization_path(organization))
        click_link "Log Out"
        request_login(organization.owner)
        current_path.should eq(user_organizations_path(organization.owner))
      end
    end
    
    context "for volunteers" do
      let(:profile) { create(:user_profile, :user => create(:user, :verified => true)) }

      it "should redirect them to create a profile if they don't have one" do
        request_login(user)
        current_path.should eq(new_volunteer_path)
      end
      it "should redirect them to the page they requested, or their project matches if they werent requesting another page" do
        visit edit_profile_path(profile)
        fill_in "Email", :with => profile.user.email
        fill_in "Password", :with => profile.user.password
        click_button "Log In"
        current_path.should eq(edit_profile_path(profile))
        click_link "Log Out"
        request_login(profile.user)
        current_path.should eq(project_matches_path)
      end
    end
    
    context "for admins" do
      let(:admin) { create(:admin) }
      let(:profile) { create(:user_profile, :user => admin) }

      it "should redirect the admin to the page they were requesting, or their user page" do
        visit edit_profile_path(profile)
        fill_in "Email", :with => admin.email
        fill_in "Password", :with => admin.password
        click_button "Log In"
        current_path.should eq(edit_profile_path(profile))
        click_link "Log Out"
        request_login(admin)
        current_path.should eq(user_path(admin))
      end
    end
  
  end

end
