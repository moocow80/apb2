class Project < ActiveRecord::Base
  include HasTags
  TAG_TYPES = %w(Skill)

  attr_accessible :name, :details, :goals, :status
  
  belongs_to  :organization

  validates_presence_of :organization_id, :name, :details, :goals 
  validates :name,
            :length => { :within => 3..100 }
  validates_inclusion_of :status, :in => %w( open closed )
  
  before_create :set_open_status 
  before_create { generate_token(:verification_token) }
  after_save :check_verification
 
  private

    def set_open_status
      self.status = "open"
    end

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while Organization.exists?(column => self[column])
    end

    def check_verification
      notify_observers(:after_verified) if verified_changed? && verified?
    end

end
