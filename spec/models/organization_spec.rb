require "spec_helper"

describe Organization do
    before(:each) do
        @owner = Factory(:user, :is_organization => true)

        @attr = {
            :name       => "Panda Kingdom",
            :mission    => "To save all pandas",
            :causes     => "Panda",
            :website    => "www.pandakingdom.org"
        }
    end

    it "should create a new instance given valid attributes" do
        @owner.organizations.create!(@attr)
    end

    describe "owner associations" do
        before(:each) do
            @organization = @owner.organizations.create(@attr)
        end

        it "should have an owner attribute" do
            @organization.should respond_to(:owner)
        end

        it "should have the right associated owner" do
            @organization.user_id.should == @owner.id
            @organization.owner.should == @owner
        end
    end
    
    describe "validations" do
        it "should require an owner id" do
            Organization.new(@attr).should_not be_valid
        end
        
        it "should require nonblank name" do
            @owner.organizations.build(@attr.merge(:name => "  ")).should_not be_valid
        end

        it "should require an 'organization' user to create" do
            @owner.toggle!(:is_organization)
            @owner.organizations.create(@attr).should_not be_valid
        end

        it "should allow an 'admin' user to create" do
            @owner.toggle!(:is_organization)
            @owner.toggle!(:is_admin)
            @owner.organizations.create(@attr).should be_valid
        end

    end
end
