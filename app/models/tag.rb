class Tag < ActiveRecord::Base
  attr_accessible :name, :tag_type

  has_many :taggeds, :foreign_key => "tag_id"

  has_many :user_profiles, :through => :taggeds, :source => :taggable, :source_type  => "UserProfile"
  has_many :projects, :through => :taggeds, :source => :taggable, :source_type  => "Project"
  has_many :organizations, :through => :taggeds, :source => :taggable, :source_type  => "Organization"

  validates_presence_of :name, :tag_type

  validates :name,
            :length => { :within => 3..30 },
            :uniqueness => { :scope => :tag_type, :message => "should have only one per type" }
  validates :tag_type,
            :length => { :within => 4..30 },
            :uniqueness => { :scope => :name, :message => "should have only one per name" }

end
