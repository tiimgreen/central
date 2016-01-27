require 'rails_helper'

describe Employee do
  let(:employee) { FactoryGirl.create(:employee) }

  subject { employee }

  # shoulda gems allows this syntax
  it { should have_many(:check_ins) }
  it { should have_many(:sick_days) }
  it { should have_many(:holiday_requests) }
end
