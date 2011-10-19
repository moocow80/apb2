class UserProfile < ActiveRecord::Base
  attr_accessible :name, :description, :website, :available

  belongs_to :user
  has_many :tags, :class_name => "UserProfileTag", :foreign_key => "user_profile_id"

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
