class CheckIn < ActiveRecord::Base
  belongs_to :employee

  validates :check_in_time, presence: true

  def time_checked_in
    time_out = check_out_time.nil? ? Time.now : check_out_time
    seconds_diff = (time_out - check_in_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60

    (hours * 60) + minutes
  end
end
