require 'spec_helper'

describe Contributor do
  let(:user) { create(:user, :verified => true) }
  let(:project) { create(:project, :verified => true) }

  before(:each) do
    @contributor = Contributor.new(:user_id => user.id, :project_id => project.id)
  end

  it "should be valid with valid attributes" do
    @contributor.should be_valid
  end
  it "should require a user id" do
    @contributor.user_id = nil
    @contributor.should_not be_valid
  end
  it "should require a project id" do
    @contributor.project_id = nil
    @contributor.should_not be_valid
  end
  it "should require a status" do
    @contributor.status = nil
    @contributor.should_not be_valid
  end
  it "should require a reason if the status is 'declined'" do
    @contributor.status = "declined"
    @contributor.reason = nil
    @contributor.should_not be_valid
  end
  it "should have a pending status by default" do
    @contributor.status.should == "pending"
  end
end
