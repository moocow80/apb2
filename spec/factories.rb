FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "testuser#{n}@example.com" }
    password "secret"
    password_confirmation "secret"
    type "volunteer"

    factory :owner do
      type "organization"
      is_organization true
    end

    factory :volunteer do
      is_organization false
    end

    factory :admin do
      is_organization false
      is_admin true
    end
  end

  factory :user_profile do
    association :user
    sequence(:name) { |n| "Test Volunteer #{n}" }
    description "This is a description"
    website "google.com"
    available true
  end

  factory :organization do
    association :owner
    sequence(:name) { |n| "Test Organization #{n}" }
    contact "Test Contact"
    contact_email "test@example.com"
    website "http://www.example.com"
    phone "555-555-5555"
    mission "Our sample mission"
    details "Our sample details"
  end

  factory :project do
    association :organization
    sequence(:title) { |n| "Test Project #{n}" }
    details "Sample project details"
    deliverables "item thats needs to be completed"
    steps "these are the project steps"
    meetings "1 meeting, 2 meeting, 3 meeting, 4"
    pro_requirements "Needs to be smart"
    time_frame "This is a time frame"
    status "open"
  end

  factory :tag do
    sequence(:name) { |n| "Test Tag #{n}" }
    sequence(:tag_type) { |n| "Test Tag Type #{n}" }
  end
end

