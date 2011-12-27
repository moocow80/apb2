module ApplicationHelper
  def tags_by_type(type)
    Tag.where(:tag_type => type)
  end

  def pagination_link(per_page)
    querystring = "?per_page=#{per_page}"
    if params[:tag_ids]
      params[:tag_ids].each { |tag_id| querystring += "&tag_ids%5B%5D=#{tag_id}" }
    end
    querystring
  end
end
