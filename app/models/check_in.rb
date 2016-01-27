class CheckIn < ActiveRecord::Base
  # Means the method #employee will return the employee that the check in
  # belongs to, will look for the employee_id field and find an Employee with
  # that ID
  belongs_to :employee

  # Ensures that the check_in_time is present when the model is created
  validates :check_in_time, presence: true

  # Returns the time checked in for self in minutes
  def time_checked_in
    # If the user is still checked in, use the current time as the check out time
    # giving the amount of time the employee is checked in, to the current
    # moment.
    time_out = check_out_time.nil? ? Time.now : check_out_time

    # Subtracting times gives the difference in seconds
    seconds_diff = (time_out - check_in_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60

    # return the number of minutes checked in
    (hours * 60) + minutes
  end
end
