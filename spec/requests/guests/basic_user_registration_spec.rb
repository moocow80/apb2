require 'spec_helper'

describe "Basic User Registration" do
  context "as a guest" do
    before(:each) do
      User.destroy_all
      visit register_path
    end
    context "with valid credentials" do
      let(:user) { build(:user) }

      before(:each) do
        fill_in "user_email", :with => user.email
        fill_in "user_password", :with => user.password
        fill_in "user_password_confirmation", :with => user.password
        choose "user_type_volunteer"
        check "terms"
        click_button "Register"
      end

      it "should create a new user" do
        User.count.should eq 1
      end
      it "should sign in the user" do
        page.should have_selector("a", :text => "Log Out")
      end
      it "should tell the user that their account whas created" do
        page.should have_content("created")
      end
      it "should not make the user an admin" do
        User.find_by_email(user.email).should_not be_is_admin
      end
      it "should send the user an email requesting they verify their account" do
        last_email.to.should eq [user.email]
      end
      it "should not set their account to verified by default" do
        User.find_by_email(user.email).should_not be_verified
      end

      context "who chooses organization" do
        let(:organization_user) { build(:user) }

        before(:each) do
          click_link "Log Out"
          visit register_path
          fill_in "user_email", :with => organization_user.email
          fill_in "user_password", :with => organization_user.password
          fill_in "user_password_confirmation", :with => organization_user.password
          choose "user_type_organization"
          check "terms"
          click_button "Register"
        end
        it "should send them to the create organization page" do
          current_path.should eq new_organization_path
        end
      end

      context "who chooses volunteer" do
        let(:volunteer_user) { build(:user) }

        before(:each) do
          click_link "Log Out"
          visit register_path
          fill_in "user_email", :with => volunteer_user.email
          fill_in "user_password", :with => volunteer_user.password
          fill_in "user_password_confirmation", :with => volunteer_user.password
          choose "user_type_volunteer"
          check "terms"
          click_button "Register"
        end
        it "should send them to the create volunteer page" do
          current_path.should eq "/volunteers/new"
        end
      end
    end

    context "with invalid credentials" do
      before(:each) do
        reset_email
        click_button "Register"
      end
      it "should not create a new user" do
        User.count.should eq 0
      end
      it "should send the user back to the register form" do
        current_path.should eq "/users"
      end
      it "should show the user the error messages" do
        page.should have_selector(".error_messages")
      end
      it "should not send any emails" do
        ActionMailer::Base.deliveries.count.should eq 0
      end
    end
  end

end
