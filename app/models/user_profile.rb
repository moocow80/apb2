class UserProfile < ActiveRecord::Base
  attr_accessible :name, :description, :website, :available, :tag_ids

  belongs_to :user
  has_many :user_profile_tags, :dependent => :destroy
  has_many :tags, :through => :user_profile_tags

  validates :user_id,
            :presence => true,
            :uniqueness => true
  validates :name,
            :presence => true,
            :length => { :within => 3..60 }
  validates :description,
            :length => { :maximum => 500 }
  validates :website,
            :length => { :maximum => 60 }
  
end
