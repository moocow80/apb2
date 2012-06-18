require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_cause_tags
    make_skill_tags
    make_admin
    make_organizations
    make_projects
  end
end

def make_admin
  admin_email = "admin@apb.org"
  admin_password = "apb2012!"
  user = User.create!(:email => admin_email, 
                  :password => admin_password, 
                  :password_confirmation => admin_password,
                  :type => 'organization')
  user.toggle!(:verified)
  user.toggle!(:is_organization)
  user.toggle!(:is_admin)
end

def make_organizations
  51.times do |n|
    person_email = "test#{n}@example.com"
    person_password = "secret"
    user = User.create!(:email => person_email, 
                  :password => person_password, 
                  :password_confirmation => person_password,
                  :type => 'organization')

    user.toggle!(:verified)
    user.toggle!(:is_organization)

    organization = user.organizations.create(
      :name => "#{Faker::Company.name} #{n}",
      :contact => Faker::Name.name,
      :contact_email => Faker::Internet.email,
      :phone => Faker::PhoneNumber.phone_number,
      :website => Faker::Internet.ip_v4_address,
      :mission => Faker::Lorem.paragraph(5),
      :details => Faker::Lorem.paragraph(5)
      )
    organization.toggle!(:verified)
  end
end

def make_projects
  Organization.where(:verified => true).each do |organization|
    3.times do
      project = organization.projects.create!(
        :name => Faker::Company.bs.titleize,
        :details => Faker::Lorem.paragraph(5),
        :goals => Faker::Lorem.paragraph(5),
        :status => 'open'
        )

      project.toggle!(:verified)
    end
  end
end

def make_cause_tags
  Tag.create(:tag_type => "Cause", :name => "Animal Rights")
  Tag.create(:tag_type => "Cause", :name => "Arts and Culture")
  Tag.create(:tag_type => "Cause", :name => "Children")
  Tag.create(:tag_type => "Cause", :name => "Civil Rights")
  Tag.create(:tag_type => "Cause", :name => "Community and Service")
  Tag.create(:tag_type => "Cause", :name => "Democracy and Politics")
  Tag.create(:tag_type => "Cause", :name => "Economic Empowerment")
  Tag.create(:tag_type => "Cause", :name => "Education")
  Tag.create(:tag_type => "Cause", :name => "Environment")
  Tag.create(:tag_type => "Cause", :name => "Food")
  Tag.create(:tag_type => "Cause", :name => "Health")
  Tag.create(:tag_type => "Cause", :name => "Houseing & Homelessness")
  Tag.create(:tag_type => "Cause", :name => "Human Rights")
  Tag.create(:tag_type => "Cause", :name => "Humanitarian Relief")
  Tag.create(:tag_type => "Cause", :name => "International Affairs")
  Tag.create(:tag_type => "Cause", :name => "Media and Public Debate")
  Tag.create(:tag_type => "Cause", :name => "Microfinance")
  Tag.create(:tag_type => "Cause", :name => "Poverty Alleviation")
  Tag.create(:tag_type => "Cause", :name => "Religion")
  Tag.create(:tag_type => "Cause", :name => "Science & Technology")
  Tag.create(:tag_type => "Cause", :name => "Senior Citizen Issues")
  Tag.create(:tag_type => "Cause", :name => "Women's issues")
end

def make_skill_tags
  Tag.create(:tag_type => "Skill", :name => "Accounting")
  Tag.create(:tag_type => "Skill", :name => "Advertising")
  Tag.create(:tag_type => "Skill", :name => "Brand Strategy")
  Tag.create(:tag_type => "Skill", :name => "Business Strategy")
  Tag.create(:tag_type => "Skill", :name => "Communications")
  Tag.create(:tag_type => "Skill", :name => "Copywriting")
  Tag.create(:tag_type => "Skill", :name => "Design")
  Tag.create(:tag_type => "Skill", :name => "Entrepreneurship")
  Tag.create(:tag_type => "Skill", :name => "Event Planning")
  Tag.create(:tag_type => "Skill", :name => "Finance")
  Tag.create(:tag_type => "Skill", :name => "Fundraising")
  Tag.create(:tag_type => "Skill", :name => "Human Resources")
  Tag.create(:tag_type => "Skill", :name => "Legal")
  Tag.create(:tag_type => "Skill", :name => "Marketing")
  Tag.create(:tag_type => "Skill", :name => "Multimedia")
  Tag.create(:tag_type => "Skill", :name => "Online Marketing")
  Tag.create(:tag_type => "Skill", :name => "Photography")
  Tag.create(:tag_type => "Skill", :name => "Public Relations")
  Tag.create(:tag_type => "Skill", :name => "Sales & Business Development")
  Tag.create(:tag_type => "Skill", :name => "Social Media")
  Tag.create(:tag_type => "Skill", :name => "Strategic Communications")
  Tag.create(:tag_type => "Skill", :name => "Strategic Marketing")
  Tag.create(:tag_type => "Skill", :name => "Strategic")
  Tag.create(:tag_type => "Skill", :name => "Technology")
  Tag.create(:tag_type => "Skill", :name => "Writing")
end
