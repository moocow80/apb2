class Project < ActiveRecord::Base
  attr_accessible :name, :details, :goals, :status, :tag_ids
  
  belongs_to  :organization
  has_many :project_tags, :dependent => :destroy
  has_many :tags, :through => :project_tags

  validates_presence_of :organization_id, :name, :details, :goals 
  validates_inclusion_of :status, :in => %w( open closed )
  
  before_create :set_open_status 
  before_create { generate_token(:verification_token) }
  after_save :check_verification
  
  def tag_with!(tag)
    project_tags.create!(:tag_id => tag.id)
  end

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
