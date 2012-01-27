require 'spec_helper'

describe "Home Page" do
  it "should have a friendly url" do
    visit "/"
    page.should have_selector(".banner")
  end
end
