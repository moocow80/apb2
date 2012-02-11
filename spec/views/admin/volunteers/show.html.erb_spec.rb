require 'spec_helper'

describe "admin/volunteers/show.html.erb" do
  before(:each) do
    @admin_volunteer = assign(:admin_volunteer, stub_model(Admin::Volunteer))
  end

  it "renders attributes in <p>" do
    render
  end
end
