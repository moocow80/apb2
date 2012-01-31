require 'spec_helper'

describe "Viewing Project Applications" do
  context "as a volunteer" do
    let(:user) { create(:volunteer, :verified => true) }
    let!(:user_profile) { create(:user_profile, :user => user) } 
    let!(:accepted) { create(:contributor, :user => user, :status => "accepted") }
    let!(:pending) { create(:contributor, :user => user) }
    let!(:declined) { create(:contributor, :user => user, :status => "declined", :reason => "The user is no good") }

    before(:each) do
      request_login(user)
      click_link "My Profile"
      within ".content" do
        click_link "Projects"
      end
    end

    it "should show the user the projects it has volunteered for" do
      page.should have_selector(".project", :count => 3)
    end
    it "should show the status of each project the user has volunteered for" do
      page.should have_content("Accepted")
      page.should have_content("Pending")
      page.should have_content("Declined")
    end
  end
end
