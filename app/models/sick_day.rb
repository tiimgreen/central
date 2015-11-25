class SickDay < ActiveRecord::Base
  belongs_to :employee

  validate :ensure_no_check_ins_on_day

  def ensure_no_check_ins_on_day
    if employee.all_check_ins_on_date(date).any?
      errors.add(:base, 'You were checked in on that day.')
    end
  end

  def self.on_date(date)
    where(date: date)
  end
end
