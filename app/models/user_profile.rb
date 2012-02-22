class UserProfile < ActiveRecord::Base
  include HasTags
  TAG_TYPES = %w(Cause Skill)

  attr_accessible :name, :phone, :current_employer, :job_title, :degrees, :experience, :website, :available, :avatar, :resume
  belongs_to :user

  phone_regex = /^[\(\)0-9\- \+\.]{10,20} *[extension\.]{0,9} *[0-9]{0,5}$/i
  
  validates_presence_of :user_id, :name, :phone

  has_attached_file :avatar,
    :styles => { :thumb => "60x60" },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml", 
    :path => "user_profiles/:id/avatar/:style.:filename"

  has_attached_file :resume,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml", 
    :path => "user_profiles/:id/resume/resume.:extension"

  validates :name, :length => { :within => 3..60 }
  validates :phone, :format => { :with => phone_regex }
  validates :current_employer, :job_title, :website, :length => { :maximum => 60 }
  validates :degrees, :experience, :length => { :maximum => 1000 }
  validates_attachment_content_type :resume, :content_type => ['application/pdf', 'application/msword', 'text/plain']

  scope :with_tags, lambda { |*tag_ids| joins(:tags).where("tags.id IN (?)", tag_ids).group("user_profiles.id") }

end
