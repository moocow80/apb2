require 'spec_helper'

describe UserProfileTag do
  before(:each) do
    @user_profile = Factory(:user_profile)
    @tag = Factory(:tag)

    @profile_tag = @user_profile.tags.build(:tag_id => @tag.id)
  end

  it "should create an instance given valid attributes" do
    @profile_tag.save!
  end
  it "should require a user_profile_id" do
    UserProfileTag.new(:tag_id => @tag.id).should_not be_valid
  end
  it "should require a tag_id" do
    UserProfileTag.new(:user_profile_id => @user_profile.id).should_not be_valid
  end
  it "should not allow duplicates" do
    @profile_tag.save
    @user_profile.tags.new(:tag_id => @tag.id).should_not be_valid
  end
end
