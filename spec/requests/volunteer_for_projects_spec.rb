require 'spec_helper'

describe "Volunteering For Projects" do
  context "as a logged in user" do
    let(:user) { create(:user, :verified => true) }
    let!(:project) { create(:project, :verified => true) }

    before(:each) do
      request_login(user)
      visit projects_path
    end
    it "should allow the user to volunteer for a project" do
      page.should have_content("Volunteer for this Project")
      lambda do
        click_link "Volunteer for this Project"
      end.should change(Contributor, :count).by(1)
    end
    it "should tell the user they have successfully volunteered" do
      click_link "Volunteer for this Project"
      page.should have_content("successfully volunteered")
    end
    it "should send the user a thank you email once they have volunteered" do
      click_link "Volunteer for this Project"
      all_mail = ActionMailer::Base.deliveries
      second_to_last_email = all_mail[all_mail.size - 2]
      second_to_last_email.subject.should eq "Thanks for volunteering for #{project.name}!"
    end
    it "should include next steps in the thank you email"
    it "should not allow the user to volunteer again for the project"
  end

  context "as the receiving organization" do
    it "should send the organization an email with the volunteers information"
    it "should suggest the next steps an organization should take in the email"
    it "should allow the organization to accept or decline the volunteer"
    it "should require the organization to say why they denied the volunteer"
  end

  context "as a guest" do
    it "should not allow the guest to volunteer for a project"
  end

end
