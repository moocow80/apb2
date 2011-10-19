class Tag < ActiveRecord::Base
  attr_accessible :name, :tag_type

  has_many :user_profile_tags, :dependent => :destroy
  has_many :user_profiles, :through => :user_profile_tags, :source => :user_profile
  has_many :users, :through => :user_profiles, :source => :user


  has_many :project_tags, :dependent => :destroy
  has_many :projects, :through => :project_tags, :source => :project

  validates :name,
            :presence => true,
            :length => { :within => 3..30 },
            :uniqueness => { :scope => :tag_type, :message => "should have only one per type" }
  validates :tag_type,
            :presence => true,
            :length => { :within => 4..30 },
            :uniqueness => { :scope => :name, :message => "should have only one per name" }

end
