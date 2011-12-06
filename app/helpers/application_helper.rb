module ApplicationHelper
  def tags_by_type(type)
    Tag.where(:tag_type => type)
  end
end
