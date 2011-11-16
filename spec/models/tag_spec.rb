require 'spec_helper'

describe Tag do
  before(:each) do
    Tag.destroy_all
    @attr = {
      :name => "accounting",
      :tag_type => "category"
    }
  end

  describe "validations" do
    it "should create a new tag instance given valid attributes" do
      Tag.create!(@attr)
    end
    it "should require a name" do
      Tag.new(@attr.merge(:name => " ")).should_not be_valid
    end
    it "should require a type" do
      Tag.new(@attr.merge(:tag_type => " ")).should_not be_valid
    end
    it "should not allow names shorter than 3 characters" do
      Tag.new(@attr.merge(:name => "a" * 2)).should_not be_valid
    end
    it "should not allow names longer than 30 characters" do
      Tag.new(@attr.merge(:name => "a" * 31)).should_not be_valid
    end
    it "should not allow types shorter than 4 characters" do
      Tag.new(@attr.merge(:tag_type => "a" * 3)).should_not be_valid
    end
    it "should not allow types longer than 30 characters" do
      Tag.new(@attr.merge(:tag_type => "a" * 31)).should_not be_valid
    end
    it "should not allow duplicate name and type" do
      Tag.create(@attr)
      Tag.new(@attr).should_not be_valid
    end
    it "should allow duplicate names of different types" do
      Tag.create(@attr)
      Tag.create(@attr.merge(:tag_type => "skill")).should be_valid
    end
    it "should allow duplicate types with different names" do
      Tag.create(@attr)
      Tag.create(@attr.merge(:name => "web design")).should be_valid
    end
  end

  describe "associations" do
    before(:each) do
      @tag = Tag.create(@attr)
    end
    it "should have a users attribute" do
      @tag.should respond_to(:users)
    end
    it "should have a projects attribute" do
      @tag.should respond_to(:projects)
    end
    it "should have the right users" do
      user = Factory(:user)
      user2 = Factory(:user)
      
      profile = Factory(:user_profile, :user => user)
      profile2 = Factory(:user_profile, :user => user2)

      user.tag_with!(@tag)
      user2.tag_with!(@tag)
      @tag.users.should include(user, user2)
    end
    it "should have the right projects" do
      project = Factory(:project)
      project2 = Factory(:project, :organization => project.organization)

      project.tag_with!(@tag)
      project2.tag_with!(@tag)
      @tag.projects.should include(project, project2)
    end
  end


end
