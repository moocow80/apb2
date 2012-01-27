require 'spec_helper'

describe "Testimonial Page" do
  it "should have a friendly url" do
    visit "/testimonials"
    within ".content" do
      page.should have_content "Testimonials"
    end
  end
end
