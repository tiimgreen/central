class EmployeeHoliday < ActiveRecord::Base
  belongs_to :employee
  belongs_to :holiday_request

  validates :date, presence: true
end
