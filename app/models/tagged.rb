class Tagged < ActiveRecord::Base
  validates_presence_of :taggable_id, :taggable_type, :tag_id
  
  belongs_to :taggable, :polymorphic => true
  belongs_to :tag
end
