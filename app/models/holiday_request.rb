class HolidayRequest < ActiveRecord::Base
  has_many :employee_holidays

  belongs_to :employees

  def date_from
    employee_holidays.order(:date).first.date
  end

  def date_to
    employee_holidays.order(:date).last.date
  end

  def total_days_requested
    count = 0

    (date_from..date_to).to_a.each do |date|
      count += 1 if is_valid_date?(date)
    end

    count
  end

  private

    def is_valid_date?(date)
      !date.saturday? && !date.sunday? && !CompanyHoliday.is_holiday?(date)
    end
end
