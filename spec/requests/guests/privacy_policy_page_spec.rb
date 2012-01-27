require 'spec_helper'

describe "Privacy Policy Page" do
  it "should have a friendly url" do
    visit "/privacy-policy"
    within ".content" do
      page.should have_content "Privacy Policy"
    end
  end
end
