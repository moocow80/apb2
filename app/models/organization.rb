class Organization < ActiveRecord::Base
    attr_accessible :name, :contact, :contact_email, :website, :phone, :mission, :details

    belongs_to  :owner, :class_name => "User", :foreign_key => "user_id"
    has_many    :projects

    validates   :user_id, :name, :contact, :contact_email, :phone, :mission, :details, :presence => true

    validates   :name, :length => { :within => 4..50 }
    validates   :contact, :length => { :within => 4..50 }
    validates   :mission, :length => { :within => 5..1000 }
    validates   :details, :length => { :within => 5..1000 }

    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    phone_regex = /^[\(\)0-9\- \+\.]{10,20} *[extension\.]{0,9} *[0-9]{0,5}$/i

    validates :contact_email,
              :format => { :with => email_regex }
    validates :phone,
              :format => { :with => phone_regex }

    validates :name,
              :uniqueness => { :case_sensitive => false }
  
    validate :require_organization_user

    before_save :sanitize_name

    def to_param
      self.name.parameterize      
    end

    private

    def require_organization_user
        if self.user_id 
            if !self.owner.is_organization? && !self.owner.is_admin?
                errors.add(:user_id, "must be an organization user")
            end
        end
    end

    def sanitize_name
      self.name = self.name.titleize
    end

end
