class ContributorObserver < ActiveRecord::Observer
  def after_create(contributor)
    UserMailer.thanks_for_volunteering(contributor).deliver
    UserMailer.new_project_volunteer(contributor).deliver
  end

  def after_update(contributor)
    UserMailer.volunteer_status_update(contributor).deliver
  end
end
