class EmployeeHoliday < ActiveRecord::Base
  belongs_to :employee
  belongs_to :holiday_request

  validates :date, presence: true

  def self.on_date(date)
    where(date: date)
  end
end
