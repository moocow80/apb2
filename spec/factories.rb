Factory.define :user, :aliases => [:owner] do |user|
  user.email "person@example.com"
  user.password "testers"
  user.password_confirmation "testers"
  user.type "organization"
  user.is_organization true
end

Factory.define :volunteer do |user|
  user.email "person@example.com"
  user.password "testers"
  user.password_confirmation "testers"
  user.type "volunteer"
  user.is_organization false
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

Factory.sequence :title do |n|
  "Title #{n}"
end

Factory.define :tag do |tag|
  tag.name "tag"
  tag.tag_type "tag type"
end

Factory.sequence :tag_name do |n|
  "tag #{n}"
end
Factory.sequence :tag_type do |n|
  "tag type #{n}"
end

Factory.define :user_profile do |profile|
  profile.association :user
  profile.name "Test User"
  profile.description "This is a description"
  profile.website "google.com"
  profile.available true
end
