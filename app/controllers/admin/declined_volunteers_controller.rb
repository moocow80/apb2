class Admin::DeclinedVolunteersController < Admin::AdminController
  def index
    @contributors = Contributor.where(:status => "declined")
  end
end
