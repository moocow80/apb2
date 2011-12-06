require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :email => "user@example.com",
      :password => "testpassword",
      :password_confirmation => "testpassword",
      :type => "volunteer"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  it "should allow valid email addresses" do
    addresses = %w[user@example.com THE_USER@my.example.net a.user@example.co]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "should not allow invalid email addresses" do
    addresses = %w[user@example,com THE_USER_my.example.net a.user@example.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should not allow duplicate email addresses" do
    User.create!(@attr)
    user_with_same_email = User.new(@attr)
    user_with_same_email.should_not be_valid
  end
  it "should not allow duplicate email addresses with different cases" do
    upper_cased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upper_cased_email))
    user_with_same_email = User.new(@attr)
    user_with_same_email.should_not be_valid
  end
  it "should not be verfied by default" do
    user = User.create!(@attr)
    user.should_not be_verified
  end
  it "should create a random email token when created" do
    user = User.create!(@attr)
    user.email_token.should_not be_nil
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    it "should require a matching password" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      short_password = "a" * 5
      User.new(@attr.merge(:password => short_password, :password_confirmation => short_password)).should_not be_valid
    end
    it "should reject long passwords" do
      long_password = "a" * 41
      hash = @attr.merge(:password => long_password, :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      it "should return nil on email does not exist" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      it "should return the user on email/password match" do
        matched_user = User.authenticate(@attr[:email], @attr[:password])
        matched_user.should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should respond to is_admin" do
      @user.should respond_to(:is_admin)
    end
    it "should not be an admin by default" do
      @user.should_not be_is_admin
    end
    it "should be convertible to an admin" do
      @user.toggle!(:is_admin)
      @user.should be_is_admin
    end
  end

  describe "organization attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should respond to is_organization" do
      @user.should respond_to(:is_organization)
    end
    it "should not be organization by default" do
      @user.should_not be_is_organization
    end
    it "should be convertible to an organization" do
      @user.toggle!(:is_organization)
      @user.should be_is_organization
    end
  end

  describe ".profile method" do
    before(:each) do
      @user = User.create(@attr)
    end

    it "should respond to .profile" do
      @user.should respond_to(:profile)
    end
    it "should return the user_profile if there is one" do
      profile = create(:user_profile, :user => @user)
      @user.profile.should eq(profile)
    end
    it "should return nil if there is not one" do
      @user.profile.should be_nil
    end
  end

end
