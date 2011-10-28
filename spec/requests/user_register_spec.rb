require 'spec_helper'

describe "When a user signs up" do
    let(:user) { User.new(:email => "test@example.com", :password => "secret", :password_confirmation => "secret")  }

    before do
      User.destroy_all
      @count = User.count

      visit register_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      fill_in "user_password_confirmation", :with => user.password
    end

    context "with valid credentials" do
      before do
        choose "user_type_volunteer"
        check "terms"
        click_button "Register"
      end
      
      it "a new user is created" do
        User.count.should eq(@count + 1)
      end
      it "the correct user is created" do
        User.find_by_email(user.email).should_not be_nil
      end
      it "the user is signed in" do
        page.should have_xpath("//a", :content => "Log Out")
      end
      it "the user is notified that an account was created" do
        page.should have_xpath("//div", :id => "flash_success", :content => "created")
      end
      it "the user is not an admin" do
        User.find_by_email(user.email).should_not be_is_admin
      end
    end

    context "with valid volunteer credentials" do
      before do
        choose "user_type_volunteer"
        check "terms"
        click_button "Register"
      end
      it "an organization user is not created" do
        User.find_by_email(user.email).should_not be_is_organization
      end
      it "the user is sent to create a volunteer profile" do
        current_path.should eq("/volunteers/new")
      end
    end

    context "with valid organization credentials" do
      before do
        choose "user_type_organization"
        check "terms"
        click_button "Register"
      end
      it "an organization user is created" do
        User.find_by_email(user.email).should be_is_organization
      end
      it "the user is sent to create an organization" do
        current_path.should eq("/organizations/new")
      end
    end

    context "with invalid credentials (no user type, no terms)" do
      it "error messages are shown" do
        click_button "Register"
        page.should have_xpath("//div", :class => "error_messages")
      end
      it "the user will be redirected back to the register page" do
        click_button "Register"
        current_path.should eq("/users")
      end
      it "a user is not created unless they have accepted the terms" do
        check "terms"
        click_button "Register"
        page.should have_xpath("//div", :class => "error_messages")
        User.count.should eq(@count)
      end
      it "a user is not created unless they have selected a user type" do
        choose "user_type_volunteer"
        click_button "Register"
        page.should have_xpath("//div", :class => "error_messages")
        User.count.should eq(@count)
      end
  end



end
