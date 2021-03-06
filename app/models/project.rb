class Project < ActiveRecord::Base
  include HasTags
  TAG_TYPES = %w(Skill)

  sluggable

  attr_accessible :name, :details, :goals, :status
  
  belongs_to  :organization
  has_many :contributions, :class_name => "Contributor", :foreign_key => "project_id"
  has_many :contributors, :through => :contributions, :source => :user

  validates_presence_of :organization_id, :details, :goals 
  validates :name,
            :length => { :within => 3..100 }
  validates_inclusion_of :status, :in => %w( pending open in_progress completed cancelled )
  
  before_create :set_open_status 
  before_create { generate_token(:verification_token) }
  after_save :check_verification
 
  scope :verified, where(:verified => true)
  scope :with_skills, lambda { |*tag_ids| joins(:tags).where("tags.id IN (?)", tag_ids).group("projects.id") }

  def self.search(search)
    escaped_search = search.gsub('%','\%').gsub('_','\_').gsub(/\\/, '\&\&').gsub(/'/, "''")
    statement =   "SELECT projects.* "
    statement +=  "FROM taggeds, tags, projects "
    statement +=  "INNER JOIN organizations ON organizations.id = projects.organization_id " 
    statement +=  "WHERE (taggeds.taggable_id = organizations.id AND taggeds.taggable_type = 'Organization' AND tags.id = taggeds.tag_id AND tags.name LIKE \"%#{escaped_search}%\") " 
    statement +=  "OR (taggeds.taggable_id = projects.id AND taggeds.taggable_type = 'Project' AND tags.id = taggeds.tag_id AND tags.name LIKE \"%#{escaped_search}%\") "
    statement +=  "OR projects.name LIKE \"%#{escaped_search}%\" "
    statement +=  "GROUP BY projects.id ORDER BY projects.name"
    statement
  end  

  def self.with_causes_sql(*tag_ids)
    statement =   "SELECT `projects`.* FROM projects "
    statement +=  "INNER JOIN organizations ON projects.organization_id = organizations.id "
    statement +=  "INNER JOIN taggeds ON taggeds.taggable_type = 'Organization' AND taggeds.taggable_id = organizations.id "
    statement +=  "INNER JOIN tags ON tags.id = taggeds.tag_id WHERE tags.id IN (#{tag_ids.join(",")}) GROUP BY projects.id ORDER BY projects.name"
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
    self.status = "open" if self.status.nil?
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
