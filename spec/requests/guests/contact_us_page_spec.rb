require 'spec_helper'

describe "Contact Us Page" do
  it "should have a friendly url" do
    visit "/contact-us"
    within ".content" do
      page.should have_content "Contact Us"
    end
  end
end
