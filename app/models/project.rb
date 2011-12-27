class Project < ActiveRecord::Base
  include HasTags
  TAG_TYPES = %w(Skill)

  sluggable

  attr_accessible :name, :details, :goals, :status
  
  belongs_to  :organization

  validates_presence_of :organization_id, :details, :goals 
  validates :name,
            :length => { :within => 3..100 }
  validates_inclusion_of :status, :in => %w( open closed )
  
  before_create :set_open_status 
  before_create { generate_token(:verification_token) }
  after_save :check_verification
 
  scope :verified, where(:verified => true)
  scope :with_skills, lambda { |*tag_ids| joins(:tags).where("tags.id IN (?)", tag_ids).group("projects.id") }

  def self.with_causes_sql(*tag_ids)
    statement =   "SELECT `projects`.* FROM projects "
    statement +=  "INNER JOIN organizations ON projects.organization_id = organizations.id "
    statement +=  "INNER JOIN taggeds ON taggeds.taggable_type = 'Organization' AND taggeds.taggable_id = organizations.id "
    statement +=  "INNER JOIN tags ON tags.id = taggeds.tag_id WHERE tags.id IN (#{tag_ids.join(",")}) GROUP BY projects.id"
    statement
  end

  def self.with_causes_and_skills_sql(cause_ids,skill_ids)
    statement =   "SELECT projects.* "
    statement +=  "FROM taggeds, projects " 
    statement +=  "INNER JOIN organizations ON organizations.id = projects.organization_id " 
    statement +=  "WHERE (taggeds.taggable_id = organizations.id AND taggeds.taggable_type = 'Organization' AND taggeds.tag_id IN (#{cause_ids})) " 
    statement +=  "OR (taggeds.taggable_id = projects.id AND taggeds.taggable_type = 'Project' AND taggeds.tag_id IN (#{skill_ids})) "
    statement +=  "GROUP BY projects.id"
    statement
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
