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
    it "should not allow short project names" do
      @organization.projects.build(@attr.merge(:name => "a" * 2)).should_not be_valid
    end
    it "should not allow long names" do
      @organization.projects.build(@attr.merge(:name => "a" * 101)).should_not be_valid
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

  describe "tags" do
    let(:project) { create(:project) }
    let(:tag1) { create(:skill_tag, :name => "Type 1") }
    let(:tag2) { create(:skill_tag, :name => "Type 2") }
    let(:tag3) { create(:cause_tag, :name => "Cause 1") }

    before(:each) do
      project.tag_with!(tag1, tag2)
    end
    it "respond to tags" do
      project.should respond_to(:tags)
    end
    it "should have the right tags" do
      project.tags.should eq([tag1, tag2])
    end
    it "should only have 'Skill' typed tags" do
      project.tag_with!(tag3)
      project.tags.each do |tag|
        tag.tag_type.should eq "Skill"
      end
    end
    it "should allow new 'Skill' type tags to be added" do
      new_tag = create(:skill_tag, :name => "New Type")
      project.tag_with!(new_tag)
      project.tags.should include(new_tag)
    end
    it "should allow tags to be removed" do
      project.drop_tags!(tag2)
      project.tags.should_not include(tag2)
    end
  end
end
