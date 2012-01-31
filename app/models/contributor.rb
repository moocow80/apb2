class Contributor < ActiveRecord::Base
  attr_accessible :user_id, :project_id, :reason, :status

  belongs_to :user
  belongs_to :project

  validates_presence_of :user_id, :project_id, :status

  validates :reason, :presence => true, :if => "status == 'declined' || status == 'quit'"
end
