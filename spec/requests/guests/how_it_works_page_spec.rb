require 'spec_helper'

describe "How It Works Page" do
  it "should have a friendly url" do
    visit "/how-it-works"
    within ".content" do
      page.should have_content "How It Works"
    end
  end
end
