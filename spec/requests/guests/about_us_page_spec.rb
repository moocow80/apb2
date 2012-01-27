require 'spec_helper'

describe "About Us Page" do
  it "should have a friendly url" do
    visit "/about-us"
    within ".content" do
      page.should have_content "About Us"
    end
  end
end
