class ProjectTag < ActiveRecord::Base
  belongs_to :project
  belongs_to :tag

  validates :project_id,
            :presence => true,
            :uniqueness => { :scope => :tag_id, :message => "should have only one of these tags" }
  validates :tag_id,
            :presence => true,
            :uniqueness => { :scope => :project_id, :message => "can only be applied to this project once" }
  
end
