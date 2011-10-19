require 'spec_helper'

describe ProjectTag do
  before(:each) do
    @project = Factory(:project)
    @tag = Factory(:tag)

    @project_tag = @project.tags.build(:tag_id => @tag.id)
  end

  it "should create an instance given valid attributes" do
    @project_tag.save!
  end
  it "should require a project_id" do
    ProjectTag.new(:tag_id => @tag.id).should_not be_valid
  end
  it "should require a tag_id" do
    ProjectTag.new(:project_id => @project.id).should_not be_valid
  end
  it "should not allow duplicates" do
    @project_tag.save
    @project.tags.new(:tag_id => @tag.id).should_not be_valid
  end
end
