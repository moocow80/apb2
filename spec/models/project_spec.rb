require 'spec_helper'

describe Project do
  before(:each) do
    @organization = Factory(:organization)
    @attr = {
      :title => "Sample Project",
      :details => "Some project details",
      :deliverables => "Some project deliverables",
      :steps => "Step 1, Step 2",
      :meetings => "Here are the meetings we will have",
      :pro_requirements => "Sample Requirements",
      :time_frame => "These are our deadlines",
      :status => "open"
    }
  end

  it "should create an instance given valid attributes" do
    @organization.projects.create!(@attr)
  end

  describe "validations" do
    it "should require a title" do
      @organization.projects.build(@attr.merge(:title => "  ")).should_not be_valid
    end
    it "should require details" do
      @organization.projects.build(@attr.merge(:details => "  ")).should_not be_valid
    end
    it "should require deliverables" do
      @organization.projects.build(@attr.merge(:deliverables => "  ")).should_not be_valid
    end
    it "should require steps" do
      @organization.projects.build(@attr.merge(:steps => "  ")).should_not be_valid
    end
    it "should require pro_requirements" do
      @organization.projects.build(@attr.merge(:pro_requirements => "  ")).should_not be_valid
    end
    it "should require time_frame" do
      @organization.projects.build(@attr.merge(:time_frame => "  ")).should_not be_valid
    end
    it "should require status" do
      @organization.projects.build(@attr.merge(:status => "  ")).should_not be_valid
    end
    it "should require a valid status" do
      @organization.projects.build(@attr.merge(:status => "invalidstatus")).should_not be_valid
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
