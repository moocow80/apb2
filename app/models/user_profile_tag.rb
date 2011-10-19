class UserProfileTag < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :tag

  validates :user_profile_id,
            :presence => true,
            :uniqueness => { :scope => :tag_id, :message => "should have only one of these tags" }
  validates :tag_id,
            :presence => true,
            :uniqueness => { :scope => :user_profile_id, :message => "can only be applied to this user once" }
end
