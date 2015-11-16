class CompanyHoliday < ActiveRecord::Base
  belongs_to :employee

  validates :date, presence: true

  def self.is_holiday?(date)
    where(date: date).any?
  end
end
