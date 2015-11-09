class CompanyHoliday < ActiveRecord::Base
  belongs_to :employee

  def self.is_holiday?(date)
    where(date: date).any?
  end
end
