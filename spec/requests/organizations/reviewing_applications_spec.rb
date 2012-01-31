require 'spec_helper'

describe "Reviewing Applications" do
  let!(:user) { create(:user, :verified => true) }
  let!(:user_profile) { create(:user_profile, :user => user) }
  let!(:project) { create(:project, :verified => true) }
  let!(:organization) { project.organization }

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
end
