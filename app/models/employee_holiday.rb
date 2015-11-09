class EmployeeHoliday < ActiveRecord::Base
  belongs_to :employee

  validates :date, presence: true
end
