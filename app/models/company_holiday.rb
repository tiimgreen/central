class CompanyHoliday < ActiveRecord::Base
  belongs_to :employee

  validates :date, presence: true, uniqueness: true

  def self.is_holiday?(date)
    where(date: date).any?
  end

  def christmas?
    date.strftime("%-d-%-m") == '25-12'
  end
end
