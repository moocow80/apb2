require 'spec_helper'

describe ContributeRelationship do
    before(:each) do
        @contributor = Factory(:user, :email => Factory.next(:email))
        @project = Factory(:project)

        @relationship = @contributor.contribute_relationships.build(:project_id => @project.id)
    end
    it "should create a new instance given valid attributes" do
        @relationship.save!
    end
    
    describe "contribute methods" do
        before(:each) do
            @relationship.save
        end
        it "should have a contributor attribute" do
            @relationship.should respond_to(:contributor)
        end
        it "should have the right contributor" do
            @relationship.contributor.should == @contributor
        end
        it "should have a project attribute" do
            @relationship.should respond_to(:project)
        end
        it "should have the right project" do
            @relationship.project.should == @project
        end
    end

    describe "validations" do
        it "should required a contributor_id" do
            @relationship.contributor_id = nil
            @relationship.should_not be_valid
        end
        it "should require a project_id" do
            @relationship.project_id = nil
            @relationship.should_not be_valid
        end
    end
end
