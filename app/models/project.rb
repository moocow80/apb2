class Project < ActiveRecord::Base
  attr_accessible :title, :details, :deliverables, :steps, :meetings, :pro_requirements, :time_frame, :status, :tag_ids
  
  belongs_to  :organization
  has_many :project_tags, :dependent => :destroy
  has_many :tags, :through => :project_tags

  validates_presence_of :organization_id, :title, :details, :deliverables, :steps, :pro_requirements, :time_frame
  validates_inclusion_of :status, :in => %w( open closed )
  
  before_create :set_open_status 
  
  def tag_with!(tag)
    project_tags.create!(:tag_id => tag.id)
  end

  private

    def set_open_status
      self.status = "open"
    end

end
