require 'rails_helper'

describe CheckIn do
  let(:check_in) { FactoryGirl.create(:check_in) }

  subject { check_in }

  it { should belong_to(:employee) }

  it { should validate_presence_of(:check_in_time) }
  it { should_not validate_presence_of(:check_out_time) }

  describe '#time_checked_in' do
    let(:check_in) do
      FactoryGirl.create(:check_in)
    end

    context 'when still checked in' do

      it 'should return correct amount of minutes' do
        expect(check_in.time_checked_in).to eq(120)
      end
    end

    context 'when checked out' do
      before { check_in.check_out_time = 2.hours.ago }

      it 'should return 0' do
        expect(check_in.time_checked_in).to eq(0)
      end
    end
  end
end
