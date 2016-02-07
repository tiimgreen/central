class HolidayRequest < ActiveRecord::Base
  include HolidaysHelper

  has_many :employee_holidays, dependent: :destroy
  belongs_to :employee
  belongs_to :authoriser, foreign_key: :authorised_by_id, class_name: :Employee

  validate :all_days_are_valid

  def all_days_are_valid
    (date_from..date_to).to_a.each do |date|
      if will_be_understaffed?(employee, date)
        errors.add(:base, "There are too many employees off on #{date.strftime("%a #{date.day.ordinalize} %B")}, please chose a range without this date.")
      end
    end

    # If employee has only requested one day off, and that day is either a weekend
    # or a company holiday, then error.
    if date_from == date_to
      if is_weekend?(date_from)
        errors.add(:base, 'That date is a weekend, please chose another date.')
      elsif is_company_holiday?(date_from)
        errors.add(:base, 'That date is a company holiday, please chose another date.')
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
    total = 0
    (date_from..date_to).each { |date| total += 1 if !is_weekend?(date) && !is_company_holiday?(date) }
    total
  end

  def approve_by(line_manager)
    create_employee_holidays
    update_attributes(authorised: true, authorised_by_id: line_manager.id)
  end

  def decline_by(line_manager)
    update_attributes(authorised: false, authorised_by_id: line_manager.id)
  end

  private

    def create_employee_holidays
      (date_from..date_to).to_a.each do |date|
        self.employee_holidays.create(date: date) if employee.is_allowed_date_off?(date)
      end
    end
end
