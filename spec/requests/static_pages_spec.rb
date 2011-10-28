require 'spec_helper'

describe "When a user visits the website" do

  it "they should see the home page" do
    visit "/"
    page.should have_selector("div.banner")
  end
end
