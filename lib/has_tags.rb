module HasTags
  extend ActiveSupport::Concern

  included do
    has_many :taggeds, :as => :taggable, :foreign_key => "taggable_id"
    has_many  :tags, :through => :taggeds

    attr_accessible :tag_ids
  end

  def tag_with!(*tags)
    tags.each do |tag|
      taggeds.create(:tag_id => tag.id) if tag.tag_type.in?(self.class::TAG_TYPES)
    end
  end

  def drop_tags!(*tags)
    tags.each do |tag|
      taggeds.find_by_tag_id(tag.id).destroy
    end
  end

  def update_tags
    unless tag_ids.nil?
      taggeds.destroy_all
      tag_ids.each do |tag_id|
        tag = Tag.find(tag_id)
        taggeds.create(:tag_id => tag.id) if tag.tag_type.in?(self.class::TAG_TYPES)
      end
    end
  end
  
end
