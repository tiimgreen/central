class HolidayRequest < ActiveRecord::Base
  include HolidaysHelper

  has_many :employee_holidays, dependent: :destroy
  belongs_to :employee

  validate :all_days_are_valid

  def all_days_are_valid
    valid = true

    (date_from..date_to).to_a.each do |date|
      if will_be_understaffed?(employee, date)
        errors.add(:base, "There are too many employees off on #{date.strftime("%a #{date.day.ordinalize} %B")}, please chose a range without this date.")
      end
    end
  end

  def start_date
    employee_holidays.order(:date).first.date
  end

  def end_date
    employee_holidays.order(:date).last.date
  end

  def total_days_requested
    employee_holidays.count
  end
end
