class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.email_verification(user).deliver
  end
end
