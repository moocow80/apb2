require 'spec_helper'

describe "Signing In" do
  let(:admin) { create(:admin) }

  context "as an admin" do
    context "with valid credentials" do
      before(:each) do
        request_login(admin)
      end

      it "should show direct the user to the admin control panel" do
        page.should have_content("Admin Control Panel")
        current_path.should eq "/admin"
      end
      it "should show a link to manage users" do
        page.should have_selector("a", :text => "Users")
      end
      it "should show a link to manage organizations" do
        page.should have_selector("a", :text => "Organizations")
      end
      it "should show a link to manage projects" do
        page.should have_selector("a", :text => "Projects")
      end
      it "should show a link to view declined volunteer reasons" do
        page.should have_selector("a", :text => "Declined Volunteers")
      end
    end

    context "with invalid credentials" do
      before(:each) do
        visit "/admin"
      end

      it "should not allow the user to view the admin control panel" do
        page.should_not have_content("Admin")
        current_path.should_not eq "/admin"
      end
      it "should send the user back to the login page" do
        page.should have_selector("form")
        current_path.should eq "/login"
      end
    end
  end
end
