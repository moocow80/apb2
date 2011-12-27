FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "testuser_#{n}@example.com" }
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
    phone "555-555-5555"
    current_employer "Sample Company"
    job_title "Sample Job Title"
    degrees "Sample Degree 1, Sample Cerification"
    experience "Sample additional experience"
    website "google.com"
    available true
  end

  factory :newsletter_subscriber do
    sequence(:email) { |n| "testsubscriber_#{n}@example.com" }
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
    sequence(:name) { |n| "Test Project #{n}" }
    details "Sample project details"
    goals "Sample project goals"
    status "open"
  end

  factory :tag do
    sequence(:name) { |n| "Test Tag #{n}" }
    tag_type "Test"

    factory :cause_tag do
      tag_type "Cause"
    end

    factory :skill_tag do
      tag_type "Skill"
    end
  end
end

