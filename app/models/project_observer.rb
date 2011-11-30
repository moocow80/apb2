class ProjectObserver < ActiveRecord::Observer
  observe :project

  def after_create(record)
    AdminMailer.project_verification(record).deliver
  end

  def after_verified(record)
    UserMailer.project_verified(record).deliver
  end

end
