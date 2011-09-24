Factory.define :user do |user|
    user.name "Sample User"
    user.email "person@example.com"
    user.password "testers"
    user.password_confirmation "testers"
end

Factory.sequence :email do |n|
    "person-#{n}@example.com"
end

Factory.define :organization do |organization|
    organization.name "Sample Organization"
    organization.mission "Our sample mission"
    organization.website "http://www.example.com"
    organization.association :user
end
