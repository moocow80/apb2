class Project < ActiveRecord::Base
    attr_accessible :title, :savings, :total_time, :description, 
                    :short_description, :deliverables, :steps, :meeting, :pro_requirements, :org_requirements, :status
    
    belongs_to  :organization

    validates   :organization_id,
                :presence => true
    validates   :title,
                :presence =>true
    validates   :savings,
                :presence =>true
    validates   :total_time,
                :presence =>true
    validates   :description,
                :presence =>true
    validates   :short_description,
                :presence =>true
    validates   :deliverables,
                :presence =>true
    validates   :steps,
                :presence =>true
    validates   :meeting,
                :presence =>true
    validates   :pro_requirements,
                :presence =>true
    validates   :org_requirements,
                :presence =>true
    validates   :status,
                :presence =>true

end
