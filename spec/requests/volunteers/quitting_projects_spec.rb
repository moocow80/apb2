require 'spec_helper'

describe "Quitting Projects" do
  let(:user) { create(:volunteer, :verified => true) }
  let!(:user_profile) { create(:user_profile, :user => user) }
  let!(:accepted) { create(:contributor, :status => "accepted", :user => user) }
  let!(:declined) { create(:contributor, :status => "declined", :user => user, :reason => "User was no good") }

  before(:each) do
    request_login(user)
    click_link "My Profile"
    within ".content" do
      click_link "Projects"
    end
  end

  context "as a volunteer" do
    it "should show the user a quit button ONLY for accepted projects" do
      page.should have_selector("input", :value => "Quit")
    end
    it "should let the user quit accepted projects" do
      fill_in "Reason", :with => "Too much work"
      click_button "Quit"
      page.should have_content("successfully quit")
    end
    it "should send the organization an email notifiying them of the quitter" do
      fill_in "Reason", :with => "Too much work"
      click_button "Quit"
      last_email.to.should eq [accepted.project.organization.owner.email]
      last_email.subject.should eq "#{user_profile.name} has quit #{accepted.project.name}."
    end
    it "should require the user to enter a reason when quitting" do
      click_button "Quit"
      page.should have_content("Reason can't be blank")
    end
  end

  context "as the organization who the volunteer quit" do
    let(:organization) { accepted.project.organization.owner }
    before(:each) do
      fill_in "Reason", :with => "Too much work"
      click_button "Quit"
      click_link "Log Out"
      request_login(organization)
      click_link "My Organizations"
      click_link accepted.project.organization.name
      click_link accepted.project.name
    end

    it "should not show the user that quit" do
      page.should_not have_content user_profile.name
    end
  end
end
