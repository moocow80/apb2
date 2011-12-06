require 'spec_helper'

describe UserProfile do
  before(:each) do
    @user = Factory(:user)
    @attr = { :name => "Test User", 
              :phone => "555-555-5555",
              :current_employer => "Sample Company",
              :job_title => "Sample Job Title",
              :degrees => "Sample degree information",
              :experience => "Sample experience information",
              :website => "http://www.google.com", 
              :available => true }
  end

  describe "validations" do
    it "should create in instance given valid attributes" do
      @user.create_user_profile!(@attr)
    end
    it "should require a user_id" do
      UserProfile.new(@attr).should_not be_valid
    end
    it "should require a name" do
      @user.build_user_profile(@attr.merge(:name => "  ")).should_not be_valid
    end
    it "should not allow names longer than 60" do
      @user.build_user_profile(@attr.merge(:name => "a" * 61)).should_not be_valid
    end
    it "should not allow names shorter than 3" do
      @user.build_user_profile(@attr.merge(:name => "a" * 2)).should_not be_valid
    end
    it "should require a phone" do
      @user.build_user_profile(@attr.merge(:phone => "   ")).should_not be_valid
    end
    it "should require a valid phone" do
      phones = %w[999 bart 99ext 999&999&9997]
      phones.each do |phone|
        @user.build_user_profile(@attr.merge(:phone => phone)).should_not be_valid
      end
    end
    it "should not allow current employer longer than 60" do
      @user.build_user_profile(@attr.merge(:current_employer => "a" * 61)).should_not be_valid
    end
    it "should not allow job titles longer than 60" do
      @user.build_user_profile(@attr.merge(:job_title => "a" * 61)).should_not be_valid
    end
    it "should not allow degree information longer than 1000" do
      @user.build_user_profile(@attr.merge(:degrees => "a" * 1001)).should_not be_valid
    end
    it "should not allow experience longer than 1000" do
      @user.build_user_profile(@attr.merge(:experience => "a" * 1001)).should_not be_valid
    end
    it "should not allow websites longer than 60" do
      @user.build_user_profile(@attr.merge(:website => "a" * 61)).should_not be_valid
    end
  end

  describe "associations" do
    before(:each) do
      @profile = @user.create_user_profile(@attr)
    end

    it "should have a user attribute" do
      @profile.should respond_to(:user)
    end
    it "should have the right user" do
      @profile.user.should == @user
      @profile.user_id.should == @user.id
    end
  end

  describe "tags" do
    let(:user_profile) { create(:user_profile) }
    let(:tag1) { create(:cause_tag) }
    let(:tag2) { create(:cause_tag) }
    let(:tag3) { create(:skill_tag) }
    let(:tag4) { create(:skill_tag) }

    before(:each) do
      user_profile.tag_with!(tag1, tag2, tag3, tag4)
    end
    it "respond to tags" do
      user_profile.should respond_to(:tags)
    end
    it "should have the right tags" do
      user_profile.tags.should eq([tag1, tag2, tag3, tag4])
    end
    it "should allow tags to be removed" do
      user_profile.drop_tags!(tag2)
      user_profile.tags.should_not include(tag2)
    end
  end
end
