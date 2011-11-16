class OrganizationObserver < ActiveRecord::Observer
  def after_create(organization)
    AdminMailer.organization_verification(organization).deliver
  end

  def after_verified(organization)
    UserMailer.organization_verified(organization).deliver
  end


end
