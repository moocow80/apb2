require 'spec_helper'

describe "Viewing Declined Volunteer Reasons" do
  let(:admin) { create(:admin) }
  let!(:c1) { create(:contributor, :status => "declined", :reason => "The volunteer was not qualified") }
  let!(:c2) { create(:contributor, :status => "declined", :reason => "We already filled the position") }
  let(:v1) { c1.user }
  let(:v2) { c2.user }

  context "as an admin" do
    before(:each) do
      request_login(admin)
      click_link "Declined Volunteers"
    end

    it "should show a list of declined volunteers" do
      page.should have_content(v1.email)
      page.should have_content(v2.email)
    end
    it "should show the reason why a volunteer was declined" do
      page.should have_content("The volunteer was not qualified")
      page.should have_content("We already filled the position")
    end
  end
end
