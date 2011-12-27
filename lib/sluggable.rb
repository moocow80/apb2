module Sluggable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def sluggable
      validates :name,
                :presence => true,
                :uniqueness => { :case_sensitive => false }

      before_save :create_slug

      class_eval <<-EOV
        include Sluggable::InstanceMethods
      EOV
    end
  end

  module InstanceMethods
    def to_param
      self.slug
    end

    def create_slug
      self.slug = self.name.parameterize
    end
  end
end
ActiveRecord::Base.send(:include, Sluggable)
