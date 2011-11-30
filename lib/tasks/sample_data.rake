require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_organizations
    make_projects
  end
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
