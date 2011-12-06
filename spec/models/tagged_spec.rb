require 'spec_helper'

describe Tagged do

  describe "validations" do
    before(:each) do
      @tagged = Tagged.new(:taggable_id => 1, :taggable_type => "Some Type", :tag_id => 1)
    end
    it "should create an instance given valid attributes" do
      @tagged.save!
    end
    it "should require a taggable_id" do
      Tagged.new(:taggable_type => "Some Type", :tag_id => 1).should_not be_valid
    end
    it "should require a taggable_type" do
      Tagged.new(:taggable_id => 1, :tag_id => 1).should_not be_valid
    end
    it "should require a tag_id" do
      Tagged.new(:taggable_id => 1, :taggable_type => "Some Type").should_not be_valid
    end
  end
end
