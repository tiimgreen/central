class HolidayRequest < ActiveRecord::Base
  has_many :employee_holidays

  belongs_to :employee

  def date_from
    employee_holidays.order(:date).first.date
  end

  def date_to
    employee_holidays.order(:date).last.date
  end

  def total_days_requested
    employee_holidays.count
  end
end
