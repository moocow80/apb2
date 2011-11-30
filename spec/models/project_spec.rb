require 'spec_helper'

describe Project do
  before(:each) do
    @organization = Factory(:organization)
    @attr = {
      :name => "Sample Project",
      :details => "Sample project details",
      :goals => "Sample project goals",
      :status => "open"
    }
  end

  it "should create an instance given valid attributes" do
    @organization.projects.create!(@attr)
  end

  describe "validations" do
    it "should require a name" do
      @organization.projects.build(@attr.merge(:name => "  ")).should_not be_valid
    end
    it "should require details" do
      @organization.projects.build(@attr.merge(:details => "  ")).should_not be_valid
    end
    it "should require goals" do
      @organization.projects.build(@attr.merge(:goals => "  ")).should_not be_valid
    end
    it "should require status" do
      @organization.projects.build(@attr.merge(:status => "  ")).should_not be_valid
    end
    it "should require a valid status" do
      @organization.projects.build(@attr.merge(:status => "invalidstatus")).should_not be_valid
    end
    it "should not be verfied by default" do
      project = @organization.projects.create!(@attr)
      project.should_not be_verified
    end
    it "should create a random email token when created" do
      project = @organization.projects.create!(@attr)
      project.verification_token.should_not be_nil
    end
  end

  describe "associations" do
    before(:each) do
      @project = @organization.projects.create(@attr)
    end

    it "should have an organization attribute" do
      @project.should respond_to(:organization)
    end
    it "should have the right organization" do
      @project.organization.should == @organization
      @project.organization_id.should == @organization.id
    end
  end

end
