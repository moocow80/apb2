class ContributeRelationship < ActiveRecord::Base
    attr_accessible :project_id

    belongs_to :contributor, :class_name => "User"
    belongs_to :project

    validates :contributor_id, :project_id, :presence => true
end
