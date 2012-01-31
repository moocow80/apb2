require 'spec_helper'

describe "Editing Organizations" do
  context "as an organization" do
    let(:organization) { create(:organization, :verified => true) }
    let!(:new_cause) { create(:cause_tag) }

    before(:each) do
      request_login(organization.owner)
      click_link "My Organizations"
      click_link organization.name
      click_link "Edit Organization Profile"
    end

    it "should show a form for editing the organization details" do
      page.should have_selector("form", :id => "edit_organization_form")
    end

    it "should only allow owners to access the edit action" do
      other_organization = create(:organization, :verified => true)
      bad_user = other_organization.owner

      click_link "Log Out"
      request_login(bad_user)
      visit edit_organization_path(organization)
      page.should_not have_selector("form", :id => "edit_organization_form")
      page.should have_content("You don't have permission to access this organization.")
    end

    context "with valid credentials" do
      let(:new_org) { build(:organization) }

      before(:each) do
        fill_in "Name of the organization/non-profit", :with => new_org.name
        fill_in "Name of the contact person", :with => new_org.contact
        fill_in "Email address of the contact person", :with => new_org.contact_email
        fill_in "Phone number", :with => new_org.phone
        fill_in "Organization website", :with => new_org.website
        fill_in "Mission statement", :with => new_org.mission
        fill_in "Organization details", :with => new_org.details
        check new_cause.name
        click_button "Update Organization"
      end
      it "should update the organization details" do
        page.should have_content(new_org.name)
        page.should have_content(new_org.contact)
        page.should have_content(new_org.contact_email)
        page.should have_content(new_org.phone)
        page.should have_content(new_org.website)
        page.should have_content(new_org.mission)
        page.should have_content(new_org.details)
        page.should have_content(new_cause.name)
      end
      it "should inform the user that the organization has been updated" do
        page.should have_content "Your organization has been successfully updated!"
      end
      it "should send the user back to the organization profile page" do
        current_path.should eq "/organizations/#{new_org.name.parameterize}"
      end
      it "should send an email to admin" do
        last_email.to.should eq [AdminMailer.default_params[:to]]
        last_email.subject.should eq "The organization #{organization.name} has been updated."
      end
    end

    context "with invalid credentials" do
      before(:each) do
        fill_in "Name of the organization/non-profit", :with => ""
        click_button "Update Organization"
      end
      it "should show the user the error messages" do
        page.should have_selector(".error_messages")
      end
      it "should send them back to the form" do
        page.should have_selector("form", :id => "edit_organization_form")
      end
    end
  end
end
