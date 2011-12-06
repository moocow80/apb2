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
    describe "user_profiles" do
      let(:tag) { create(:skill_tag) }
      let(:up1) { create(:user_profile) }
      let(:up2) { create(:user_profile) }

      before(:each) do
        up1.tag_with!(tag)
        up2.tag_with!(tag)
      end
      it "should return the user profiles for that tag" do
        tag.user_profiles.should eq([up1, up2])
      end
    end

    describe "projects" do
      let(:tag) { create(:skill_tag) }
      let(:p1) { create(:project) }
      let(:p2) { create(:project) }

      before(:each) do
        p1.tag_with!(tag)
        p2.tag_with!(tag)
      end
      it "should return the projects for that tag" do
        tag.projects.should eq([p1, p2])
      end
    end

    describe "organizations" do
      let(:tag) { create(:cause_tag) }
      let(:o1) { create(:organization) }
      let(:o2) { create(:organization) }

      before(:each) do
        o1.tag_with!(tag)
        o2.tag_with!(tag)
      end
      it "should return the organizations for that tag" do
        tag.organizations.should eq([o1, o2])
      end
    end
  end


end
