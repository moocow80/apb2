require "spec_helper"

describe UserMailer do
  describe "email_verification" do
    let(:user) { Factory(:user) }
    let(:mail) { UserMailer.email_verification(user) }

    it "renders the headers" do
      mail.subject.should eq("Verify your email address for AustinProBono.org")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@austinprobono.org"])
    end
    it "renders the body" do
      mail.body.encoded.should match(email_verification_path(user.email_token))
    end
  end

  describe "organization_verified" do
    let(:organization) { create(:organization, :verified => true) }
    let(:mail) { UserMailer.organization_verified(organization) }

    it "renders the headers" do
      mail.subject.should eq("#{organization.name} has been verified!")
      mail.to.should eq([organization.owner.email])
      mail.from.should eq(["noreply@austinprobono.org"])
    end
    it "renders the body" do
      mail.body.encoded.should match(organization_url(organization))
    end
  end

  describe "project_verified" do
    let(:project) { create(:project, :verified => true) }
    let(:mail) { UserMailer.project_verified(project) }

    it "renders the headers" do
      mail.subject.should eq("#{project.name} has been verified!")
      mail.to.should eq([project.organization.owner.email])
      mail.from.should eq(["noreply@austinprobono.org"])
    end
    it "renders the body" do
      mail.body.encoded.should match(organization_project_url(project.organization, project))
    end
  end

  describe "thanks_for_volunteering" do
    let(:user) { create(:user, :verified => true) }
    let(:project) { create(:project, :verified => true) }

    before(:each) do
      @contributor = project.contributions.create(:user_id => user.id)
      @mail = UserMailer.thanks_for_volunteering(@contributor)
    end

    it "renders the headers" do
      @mail.subject.should eq("Thanks for volunteering for #{project.name}!")
      @mail.to.should eq([user.email])
      @mail.from.should eq(["noreply@austinprobono.org"])
    end
  end

  describe "new_project_volunteer" do
    let(:user) { create(:user, :verified => true) }
    let(:project) { create(:project, :verified => true) }

    before(:each) do
      @contributor = project.contributions.create(:user_id => user.id)
      @mail = UserMailer.new_project_volunteer(@contributor)
    end

    it "renders the headers" do
      @mail.subject.should eq("#{user.email} has volunteered for #{project.name}!")
      @mail.to.should eq([project.organization.owner.email])
      @mail.from.should eq(["noreply@austinprobono.org"])
    end
  end

  describe "volunteer_status_update" do
    let(:user) { create(:user, :verified => true) }
    let(:project) { create(:project, :verified => true) }

    before(:each) do
      @contributor = project.contributions.create(:user_id => user.id)
      @mail = UserMailer.volunteer_status_update(@contributor)
    end

    it "renders the headers" do
      @mail.subject.should eq("Your status for #{project.name} is now #{@contributor.status}!")
      @mail.to.should eq([user.email])
      @mail.from.should eq(["noreply@austinprobono.org"])
    end
  end
end
