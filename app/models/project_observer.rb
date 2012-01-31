class ProjectObserver < ActiveRecord::Observer
  observe :project

  def after_create(record)
    AdminMailer.project_verification(record).deliver
  end

  def after_verified(record)
    UserMailer.project_verified(record).deliver
  end

  def after_update(record)
    UserMailer.project_updated(record).deliver
  end

end
