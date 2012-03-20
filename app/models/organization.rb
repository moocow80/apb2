class Organization < ActiveRecord::Base
  include HasTags
  TAG_TYPES = %w(Cause)

  sluggable

  attr_accessible :name, :contact, :contact_email, :website, :phone, :mission, :details, :slug

  belongs_to  :owner, :class_name => "User", :foreign_key => "user_id"
  has_many    :projects

  validates   :user_id, :contact, :contact_email, :phone, :mission, :details, :presence => true

  validates   :name, :length => { :within => 4..50 }
  validates   :contact, :length => { :within => 4..50 }
  validates   :mission, :length => { :within => 5..1000 }
  validates   :details, :length => { :within => 5..1000 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  phone_regex = /^[\(\)0-9\- \+\.]{10,20} *[extension\.]{0,9} *[0-9]{0,5}$/i

  validates :contact_email,
            :format => { :with => email_regex }
  validates :phone,
            :format => { :with => phone_regex }

  validate :require_organization_user

  before_create { generate_token(:verification_token) }
  before_save :sanitize_name
  after_save :check_verification

  scope :verified, where(:verified => true)
  scope :with_causes, lambda { |*tag_ids| joins(:tags).where("tags.id IN (?) AND tags.tag_type = 'Cause'", tag_ids).group("`organizations`.`id`") }

  def self.search(search)
    escaped_search = search.gsub('%','\%').gsub('_','\_').gsub(/\\/, '\&\&').gsub(/'/, "''")
    statement =   "SELECT organizations.* "
    statement +=  "FROM taggeds, tags, organizations "
    statement +=  "LEFT JOIN projects ON organizations.id = projects.organization_id " 
    statement +=  "WHERE (taggeds.taggable_id = organizations.id AND taggeds.taggable_type = 'Organization' AND taggeds.tag_id = tags.id AND tags.name LIKE \"%#{escaped_search}%\") " 
    statement +=  "OR (taggeds.taggable_id = projects.id AND taggeds.taggable_type = 'Project' AND taggeds.tag_id = tags.id AND tags.name LIKE \"%#{escaped_search}%\") "
    statement +=  "OR organizations.name LIKE \"%#{escaped_search}%\" "
    statement +=  "GROUP BY organizations.id"
    statement
  end  

  def self.with_skills_sql(*tag_ids)
    statement =   "SELECT `organizations`.* FROM organizations "
    statement +=  "LEFT JOIN projects ON projects.organization_id = organizations.id "
    statement +=  "INNER JOIN taggeds ON taggeds.taggable_type = 'Project' AND taggeds.taggable_id = projects.id "
    statement +=  "INNER JOIN tags ON tags.id = taggeds.tag_id WHERE tags.id IN (#{tag_ids.join(",")}) GROUP BY organizations.id"
    statement
  end

  def self.with_causes_and_skills_sql(cause_ids,skill_ids)
    statement =   "SELECT organizations.* "
    statement +=  "FROM taggeds, organizations " 
    statement +=  "LEFT JOIN projects ON organizations.id = projects.organization_id " 
    statement +=  "WHERE (taggeds.taggable_id = organizations.id AND taggeds.taggable_type = 'Organization' AND taggeds.tag_id IN (#{cause_ids})) " 
    statement +=  "OR (taggeds.taggable_id = projects.id AND taggeds.taggable_type = 'Project' AND taggeds.tag_id IN (#{skill_ids})) "
    statement +=  "GROUP BY organizations.id"
    statement
  end

  private

  def require_organization_user
      if self.user_id 
          if !self.owner.is_organization? && !self.owner.is_admin?
              errors.add(:user_id, "must be an organization user")
          end
      end
  end

  def sanitize_name
    self.name = self.name.titleize
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
