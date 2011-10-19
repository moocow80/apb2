class User < ActiveRecord::Base
  attr_accessor :password 
  attr_accessible :email, :password, :password_confirmation, :terms, :type

  has_many :organizations

  has_many :user_profiles, :dependent => :destroy
  has_many :user_profile_tags, :through => :user_profiles
  has_many :tags, :through => :user_profile_tags, :source => :tag

  has_many :contribute_relationships, :foreign_key => "contributor_id", :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, 
            :presence => true, 
            :format => { :with => email_regex }, 
            :uniqueness => { :case_sensitive => false }
  validates :password, 
            :presence => true, 
            :confirmation => true, 
            :length => { :within => 6..40 }
  validates_acceptance_of :terms
  validates_inclusion_of :type, :in => ["organization", "volunteer"]

  before_save :encrypt_password

  def type
    @type
  end

  def type=(new_type)
    @type = new_type
  end
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.salt == cookie_salt
  end  

  def tag_with!(tag)
    self.user_profiles.first.tags.create!(:tag_id => tag.id) unless self.user_profiles.first == nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
