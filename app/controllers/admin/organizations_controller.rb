class Admin::OrganizationsController < Admin::AdminController
  def index
    per_page = params[:per_page] || 20
    if params[:cause_tag_ids] && params[:skill_tag_ids]
      sql = Organization.with_causes_and_skills_sql(params[:cause_tag_ids].join(","), params[:skill_tag_ids].join(","))
      @organizations = Organization.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
    elsif params[:cause_tag_ids]
      sql = Organization.with_causes(params[:cause_tag_ids].join(",")).to_sql
      @organizations = Organization.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
    elsif params[:skill_tag_ids]
      sql = Organization.with_skills_sql(params[:skill_tag_ids].join(","))
      @organizations = Organization.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
    else
      @organizations = Organization.all
    end
  end
end
