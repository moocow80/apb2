class Admin::ProjectsController < Admin::AdminController
  def index
    per_page = params[:per_page] || 20
    if params[:cause_tag_ids] && params[:skill_tag_ids]
      sql = Project.with_causes_and_skills_sql(params[:cause_tag_ids].join(","), params[:skill_tag_ids].join(","))
      @projects = Project.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
    elsif params[:cause_tag_ids]
      sql = Project.with_causes_sql(params[:cause_tag_ids].join(","))
      @projects = Project.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
    elsif params[:skill_tag_ids]
      sql = Project.with_skills(params[:skill_tag_ids].join(",")).to_sql
      @projects = Project.paginate_by_sql(sql, :page => params[:page], :per_page => per_page)
    else
      @projects = Project.all
    end
  end
end
