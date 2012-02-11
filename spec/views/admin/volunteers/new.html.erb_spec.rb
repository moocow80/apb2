require 'spec_helper'

describe "admin/volunteers/new.html.erb" do
  before(:each) do
    assign(:admin_volunteer, stub_model(Admin::Volunteer).as_new_record)
  end

  it "renders new admin_volunteer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_volunteers_path, :method => "post" do
    end
  end
end
