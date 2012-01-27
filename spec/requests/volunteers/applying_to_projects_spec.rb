require 'spec_helper'

describe "Applying to Projects" do
  let!(:user) { create(:user, :verified => true) }
  let!(:user_profile) { create(:user_profile, :user => user) }
  let!(:project) { create(:project, :verified => true) }
  let!(:organization) { project.organization }

  context "as a logged in user" do
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
    it "should not allow the user to volunteer again for the project" do
      click_link "Volunteer for this Project"
      page.should_not have_selector("a", :text => "Volunteer for this Project")
      visit "/projects"
      page.should_not have_selector("a", :text => "Volunteer for this Project")
    end
  end

  context "as the receiving organization" do
    before(:each) do
      request_login(user)
      visit projects_path
      click_link "Volunteer for this Project"
    end
    it "should send the organization an email with the volunteers information" do
      last_email.to.should eq [organization.owner.email]
    end
    it "should suggest the next steps an organization should take in the email"

    context "who accepts the volunteer" do
      before(:each) do
        click_link "Log Out"
        request_login(organization.owner)
        visit organization_project_path(organization, project)
        select "Accepted", :from => "Status"
        click_button "Save"
      end
      it "should allow the organization to accept the volunteer" do
        page.should have_content "#{user.user_profile.name} was accepted as a volunteer."
      end
      it "should email the volunteer with the status 'accepted'" do
        last_email.to.should eq [user.email]
        last_email.subject.should eq "You have been accepted as a volunteer for #{project.name}."
      end
    end

    context "who declines the volunteer" do
      before(:each) do
        click_link "Log Out"
        request_login(organization.owner)
        visit organization_project_path(organization, project)
        select "Declined", :from => "Status"
      end
      it "should allow the organization to decline the volunteer" do
        fill_in "Reason", :with => "Not qualified"
        click_button "Save"
        page.should have_content "#{user.user_profile.name} was declined as a volunteer."
      end
      it "should require the organization to say why they declined the volunteer" do
        click_button "Save"
        page.should have_content("Reason can't be blank")
      end
      it "should email the volunteer with the status declined" do
        fill_in "Reason", :with => "Not qualified"
        click_button "Save"
        last_email.to.should eq [user.email]
        last_email.subject.should eq "You have been declined as a volunteer for #{project.name}."
      end
    end
  end

  context "as a guest" do
    it "should not allow the guest to volunteer for a project" do
      visit projects_path
      page.should_not have_selector("a", :text => "Volunteer for this Project")
    end
  end

end
