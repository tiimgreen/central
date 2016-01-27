require 'rails_helper'

describe Employee do
  let(:employee) { FactoryGirl.create(:employee) }

  subject { employee }

  # shoulda gems allows this syntax
  it { should have_many(:check_ins) }
  it { should have_many(:sick_days) }
  it { should have_many(:holiday_requests) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:job_title) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:date_of_birth) }
  it { should validate_presence_of(:contracted_hours) }
  it { should validate_presence_of(:emergency_contact_name) }
  it { should validate_presence_of(:emergency_contact_relation) }
  it { should validate_presence_of(:emergency_contact_phone_number) }
end
