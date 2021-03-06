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
  it { should be_active }

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

  describe '#subordinates' do
    context 'when employee has subordinates' do
      let!(:subordinate_1) { FactoryGirl.create(:employee, line_manager_id: employee.id) }
      let!(:subordinate_2) { FactoryGirl.create(:employee, line_manager_id: employee.id) }

      it 'returns the subordinates' do
        expect(employee.subordinates.to_a).to eq([subordinate_1, subordinate_2])
      end
    end

    context 'when employee has no subordinates' do
      it 'returns the subordinates' do
        expect(employee.subordinates.to_a).to eq([])
      end
    end
  end

  describe '#checked_in?' do
    context 'when checked in' do
      before { employee.check_in }

      it 'returns true' do
        expect(employee.checked_in?).to eq(true)
      end
    end

    context 'when not checked in' do
      it 'returns false' do
        expect(employee.checked_in?).to eq(false)
      end
    end
  end

  describe '#minutes_checked_in_on_date' do
    context 'when checked in' do
      let!(:employee) { FactoryGirl.create(:employee) }
      let!(:check_in) { FactoryGirl.create(:check_in, employee: employee, check_in_time: 2.minutes.ago) }

      it 'returns the minutes checked in' do
        expect(employee.minutes_checked_in_on_date(Date.today)).to eq(2)
      end
    end

    context 'when not checked in' do
      let(:employee) { FactoryGirl.create(:employee) }

      it 'returns 0' do
        expect(employee.minutes_checked_in_on_date(Date.today)).to eq(0)
      end
    end
  end
end
