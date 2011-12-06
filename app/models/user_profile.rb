class UserProfile < ActiveRecord::Base
  include HasTags
  TAG_TYPES = %w(Cause Skill)

  attr_accessible :name, :phone, :current_employer, :job_title, :degrees, :experience, :website, :available

  belongs_to :user

  phone_regex = /^[\(\)0-9\- \+\.]{10,20} *[extension\.]{0,9} *[0-9]{0,5}$/i
  
  validates_presence_of :user_id, :name, :phone

  validates :name, :length => { :within => 3..60 }
  validates :phone, :format => { :with => phone_regex }
  validates :current_employer, :job_title, :website, :length => { :maximum => 60 }
  validates :degrees, :experience, :length => { :maximum => 1000 }
 
end
