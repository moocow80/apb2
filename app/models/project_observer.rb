class ProjectObserver < ActiveRecord::Observer
  observe :project

  def after_create(record)
    AdminMailer.project_verification(record).deliver

    tag_ids = record.tags.map(&:id).join(",") + "," + record.organization.tags.map(&:id).join(",")
    user_profiles = UserProfile.with_tags(tag_ids)

    user_profiles.each do |user_profile|
      UserMailer.notify_subscribers(record, user_profile.user).deliver
    end
  end

  def after_verified(record)
    UserMailer.project_verified(record).deliver
  end

  def after_update(record)
    UserMailer.project_updated(record).deliver
  end

end
