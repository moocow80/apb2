require "spec_helper"

describe Organization do
  it_behaves_like "it has a url slug"

  before(:each) do
    @owner = Factory(:user, :is_organization => true)

    @attr = {
      :name       => "Sample Organization",
      :contact      => "Test User",
      :contact_email  => "test@example.com",
      :website      => "www.testorg.org",
      :phone      => "555-555-5555",
      :mission      => "We are on a mission",
      :details      => "Here are some details"
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
    it "should not allow long names" do
      @owner.organizations.build(@attr.merge(:name => "a" * 51)).should_not be_valid
    end
    it "should not allow duplicate names" do
      @owner.organizations.create(@attr)
      @owner.organizations.build(@attr).should_not be_valid
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
    it "should require a contact" do
      @owner.organizations.build(@attr.merge(:contact => "  ")).should_not be_valid
    end
    it "should not allow short contact names" do
      @owner.organizations.build(@attr.merge(:contact => "a" * 3)).should_not be_valid
    end
    it "should not allow long contact names" do
      @owner.organizations.build(@attr.merge(:contact => "a" * 51)).should_not be_valid
    end
    it "should require a contact email" do
      @owner.organizations.build(@attr.merge(:contact_email => "  ")).should_not be_valid
    end
    it "should allow valid emails" do
      addresses = %w[user@example.com THE_USER@my.example.net a.user@example.co]
      addresses.each do |address|
      valid_email = @owner.organizations.new(@attr.merge(:contact_email => address))
      valid_email.should be_valid
      end
    end
    it "should not allow invalid emails" do
      addresses = %w[user@example,com THE_USER_my.example.net a.user@example.]
      addresses.each do |address|
      invalid_email = @owner.organizations.new(@attr.merge(:contact_email => address))
      invalid_email.should_not be_valid
      end
    end
    it "should require a phone" do
      @owner.organizations.build(@attr.merge(:phone => "  ")).should_not be_valid
    end
    it "should not allow invalid phone numbers" do
      phones = %w[999 bart 99ext 999&999&9997]
      phones.each do |phone|
        @owner.organizations.build(@attr.merge(:phone => phone)).should_not be_valid
      end
    end
    it "should require a mission" do
      @owner.organizations.build(@attr.merge(:mission => "  ")).should_not be_valid
    end
    it "should not allow short missions" do
      @owner.organizations.build(@attr.merge(:mission => "a" * 4)).should_not be_valid
    end
    it "should no allow long missions" do
      @owner.organizations.build(@attr.merge(:mission => "a" * 1001)).should_not be_valid
    end
    it "should require details" do
      @owner.organizations.build(@attr.merge(:details => "  ")).should_not be_valid
    end
    it "should not allow short details" do
      @owner.organizations.build(@attr.merge(:details => "a" * 4)).should_not be_valid
    end
    it "should no allow long details" do
      @owner.organizations.build(@attr.merge(:details => "a" * 1001)).should_not be_valid
    end
    it "should not be verfied by default" do
      organization = @owner.organizations.create!(@attr)
      organization.should_not be_verified
    end
    it "should create a random email token when created" do
      organization = @owner.organizations.create!(@attr)
      organization.verification_token.should_not be_nil
    end

  end


  describe "tags" do
    let(:organization) { create(:organization) }
    let(:tag1) { create(:cause_tag, :name => "Cause 1") }
    let(:tag2) { create(:cause_tag, :name => "Cause 2") }
    let(:tag3) { create(:tag) }

    before(:each) do
      organization.tag_with!(tag1, tag2)
    end
    it "respond to tags" do
      organization.should respond_to(:tags)
    end
    it "should have the right tags" do
      organization.tags.should eq([tag1, tag2])
    end
    it "should only have 'Cause' typed tags" do
      organization.tag_with!(tag3)
      organization.tags.each do |tag|
        tag.tag_type.should eq "Cause"
      end
    end
    it "should allow new 'Cause' type tags to be added" do
      new_tag = create(:cause_tag, :name => "New Cause")
      organization.tag_with!(new_tag)
      organization.tags.should include(new_tag)
    end
    it "should allow tags to be removed" do
      organization.drop_tags!(tag2)
      organization.tags.should_not include(tag2)
    end
  end
end
