Factory.define :user, :aliases => [:owner] do |user|
    user.name "Sample User"
    user.email "person@example.com"
    user.password "testers"
    user.password_confirmation "testers"
    user.is_organization true
end

Factory.sequence :email do |n|
    "person-#{n}@example.com"
end

Factory.define :organization do |organization|
    organization.name "Sample Organization"
    organization.mission "Our sample mission"
    organization.website "http://www.example.com"
    organization.association :owner
end

Factory.define :project do |project|
    project.association :organization
    project.title "Motion Graphics Video"
    project.savings "10,000"
    project.total_time "50"
    project.description "Some long text description"
    project.short_description "Some short text description"
    project.deliverables "item thats needs to be completed"
    project.steps "these are the project steps"
    project.meeting "1 meeting, 2 meeting, 3 meeting, 4"
    project.pro_requirements "Needs to be smart"
    project.org_requirements "Needs to be needy"
    project.status "open"
end
