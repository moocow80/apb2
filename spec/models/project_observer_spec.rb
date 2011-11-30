require 'spec_helper'

describe ProjectObserver do
  describe "after_create" do
    it "emails an admin asking them to verify the project" do
      project = build(:project)
      project.save
      last_email.subject.should eq("Please verify #{project.name}")
    end
  end

  describe "after_verified" do
    it "should send an email to a project owner if their project has been verified" do
      project = create(:project)
      reset_email
      project.toggle!(:verified)
      last_email.to.should include(project.organization.owner.email)
    end
    it "should not send an email when an owner edits a verified project" do
      project = create(:project, :verified => true)
      reset_email
      project.update_attribute(:name, "Some New Name")
      last_email.should be_nil
    end
  end
end
