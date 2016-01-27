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

  it { should allow_value(Faker::Internet.email).for(:email) }
  it { should_not allow_value(Faker::Internet.user_name).for(:email) }

  it { should_not be_is_line_manager }
  it { should be_active}

  describe '#full_name' do
    it 'returns full name' do
      expect(employee.full_name).to eq("#{employee.first_name} #{employee.last_name}")
    end
  end

  describe '#line_manager' do
    context 'when employee doesn\'t have line manager' do
      before { employee.line_manager_id = nil }

      it 'returns nil' do
        expect(employee.line_manager).to eq(nil)
      end
    end

    context 'when employee has line manager' do
      let(:line_manager) { FactoryGirl.create(:employee) }

      it 'returns the line manager' do
        employee.line_manager_id = line_manager.id
        expect(employee.line_manager).to eq(line_manager)
      end
    end
  end
end
