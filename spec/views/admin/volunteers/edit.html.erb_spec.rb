require 'spec_helper'

describe "admin/volunteers/edit.html.erb" do
  before(:each) do
    @admin_volunteer = assign(:admin_volunteer, stub_model(Admin::Volunteer))
  end

  it "renders the edit admin_volunteer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_volunteers_path(@admin_volunteer), :method => "post" do
    end
  end
end
