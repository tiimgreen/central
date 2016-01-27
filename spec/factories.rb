Faker::Config.locale = 'en-GB'

FactoryGirl.define do
  factory :employee do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    post_code { Faker::Address.postcode }
    date_of_birth { Faker::Date.between(70.years.ago, Date.today) }

    start_date { Date.today }
    contracted_hours { 37.5 }
    job_title { Faker::Name.title }

    emergency_contact_name { Faker::Name.name }
    emergency_contact_relation { "Mother" }
    emergency_contact_phone_number { Faker::PhoneNumber.phone_number }
  end
end
