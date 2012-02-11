require 'spec_helper'

describe "admin/volunteers/index.html.erb" do
  before(:each) do
    assign(:admin_volunteers, [
      stub_model(Admin::Volunteer),
      stub_model(Admin::Volunteer)
    ])
  end

  it "renders a list of admin/volunteers" do
    render
  end
end
