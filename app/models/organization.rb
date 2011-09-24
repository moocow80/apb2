class Organization < ActiveRecord::Base
    attr_accessible :name, :mission, :website

    belongs_to  :owner, :class_name => "User", :foreign_key => "user_id"

    validates   :user_id, :name, :mission, :presence => true

    validates   :name,
                :length => { :maximum => 50 }

    validate :require_organization_user

    private

    def require_organization_user
        if self.user_id 
            if !self.owner.is_organization? && !self.owner.is_admin?
                errors.add(:user_id, "must be an organization user")
            end
        end
    end
end
