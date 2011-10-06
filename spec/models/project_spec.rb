require 'spec_helper'

describe Project do
    before(:each) do
        @organization = Factory(:organization)
        
        @attr = {
            :title => "Motion Graphics Video",
            :savings => "10,000", # Dollars
            :total_time => "50", # Hours
            :description => "Some long text description", # HTML
            :short_description => "Some short text description", # Text
            :deliverables => "item thats needs to be completed", # HTML
            :steps => "these are the project steps", # HTML
            :meeting => "1 meeting, 2 meeting, 3 meeting, 4", # HTML
            :pro_requirements => "Needs to be smart", # HTML
            :org_requirements => "Needs to be needy", # HTML
            :status => "open"
        }
    end
    
    it "should create a new instance given valid attributes" do
        @organization.projects.create!(@attr)
    end

    describe "project associations" do
        before(:each) do
            @project = @organization.projects.create(@attr)
        end
        it "should have an organization attribute" do
            @project.should respond_to(:organization)
        end
        it "should have the right associated organization" do
            @project.organization_id.should == @organization.id
            @project.organization.should == @organization
        end
    end

    describe "validations" do
        it "should require an organization id" do
            Project.new(@attr).should_not be_valid
        end 

        describe "nonblank" do
            it "should require nonblank title" do
                @organization.projects.build(@attr.merge(:title => "  ")).should_not be_valid
            end
            it "should require nonblank savings" do
                @organization.projects.build(@attr.merge(:savings => "  ")).should_not be_valid
            end
            it "should require nonblank total_time" do
                @organization.projects.build(@attr.merge(:total_time => "  ")).should_not be_valid
            end
            it "should require nonblank description" do
                @organization.projects.build(@attr.merge(:description => "  ")).should_not be_valid
            end
            it "should require nonblank short_description" do
                @organization.projects.build(@attr.merge(:short_description => "  ")).should_not be_valid
            end
            it "should require nonblank deliverables" do
                @organization.projects.build(@attr.merge(:deliverables => "  ")).should_not be_valid
            end
            it "should require nonblank steps" do
                @organization.projects.build(@attr.merge(:steps => "  ")).should_not be_valid
            end
            it "should require nonblank meeting" do
                @organization.projects.build(@attr.merge(:meeting => "  ")).should_not be_valid
            end
            it "should require nonblank pro_requirements" do
                @organization.projects.build(@attr.merge(:pro_requirements => "  ")).should_not be_valid
            end
            it "should require nonblank org_prerequisites" do
                @organization.projects.build(@attr.merge(:org_requirements => "  ")).should_not be_valid
            end
            it "should require nonblank status" do
                @organization.projects.build(@attr.merge(:status => "  ")).should_not be_valid
            end
        end

    end

end
