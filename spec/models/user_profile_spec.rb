require 'spec_helper'

describe UserProfile do
  before(:each) do
    @user = Factory(:user)
    @attr = { :name => "Test User", :description => "This is a sample description for a user profile", :website => "http://www.google.com", :available => true }
  end

  describe "validations" do
    it "should create in instance given valid attributes" do
      @user.user_profiles.create!(@attr)
    end
    it "should require a user_id" do
      UserProfile.new(@attr).should_not be_valid
    end
    it "should not allow more than one profile per user" do
      @user.user_profiles.create(@attr)
      @user.user_profiles.build(@attr).should_not be_valid
    end
    it "should require a name" do
      @user.user_profiles.build(@attr.merge(:name => "  ")).should_not be_valid
    end
    it "should not allow names longer than 60" do
      @user.user_profiles.build(@attr.merge(:name => "a" * 61)).should_not be_valid
    end
    it "should not allow names shorter than 3" do
      @user.user_profiles.build(@attr.merge(:name => "a" * 2)).should_not be_valid
    end
    it "should not allow websites longer than 60" do
      @user.user_profiles.build(@attr.merge(:website => "a" * 61)).should_not be_valid
    end
    it "should limit description to 500 characters" do
      @user.user_profiles.build(@attr.merge(:description => "a" * 501)).should_not be_valid
    end
  end

  describe "associations" do
    before(:each) do
      @profile = @user.user_profiles.create(@attr)
    end

    it "should have a user attribute" do
      @profile.should respond_to(:user)
    end
    it "should have the right user" do
      @profile.user.should == @user
      @profile.user_id.should == @user.id
    end
  end
end
