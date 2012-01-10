require 'spec_helper'

describe ContributorObserver do
  let(:user) { create(:user, :verified => true) }
  let(:project) { create(:project, :verified => true) }

  before(:each) do
    reset_email
    @contribution = project.contributions.create(:user_id => user.id)
  end

  context 'after create' do
    it "should email the user thanking them for volunteering to the project" do
      all_mail = ActionMailer::Base.deliveries
      second_to_last_email = all_mail[all_mail.size - 2]
      second_to_last_email.to.should include(user.email)
    end
    it "should email the project owner to let them know someone has volunteered, and what they should do next" do
      last_email.to.should include(project.organization.owner.email)
    end
  end

  context 'after save' do
    before(:each) do
      reset_email
      @contribution.update_attributes(:status => "accepted")
    end
    it "should email the user with a status update" do
      last_email.to.should include(user.email)
    end
  end
end
