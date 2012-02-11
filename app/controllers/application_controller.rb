class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def not_found
    raise ActiveRecord::RecordNotFound
  end
end
