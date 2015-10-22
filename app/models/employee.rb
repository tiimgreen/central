class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :check_ins

  def full_name
    "#{first_name} #{last_name}"
  end

  # Is self checked in currently
  #
  # @returns (Boolean)
  def checked_in?
    check_ins.last.check_out_time.nil?
  end

  # Returns the time self was checked in on a given date in the format:
  #  6h 36m
  #
  # @param (Date) - the date the user was checked in
  # @returns (String) - formatted time checked in
  def time_checked_in(date)
    total_hours = total_minutes = 0

    # Gets all CheckIns from given date, including ones where user is currently
    # checked in
    check_ins_on_date = check_ins.where(
      '(check_in_time >= ? AND check_in_time <= ?) AND ' +
      '(check_out_time <= ? OR check_out_time is NULL)',
      date.to_date.beginning_of_day,
      date.to_date.end_of_day,
      date.to_date.end_of_day
    )

    check_ins_on_date.each { |check_in| total_minutes += check_in.time_checked_in }

    return if total_minutes == 0 # do not return string if user was not checked in

    if total_minutes >= 60
      # Will return how many times total_minutes goes into 60, without remainder
      total_hours = total_minutes / 60
      total_minutes -= (total_hours * 60)
    end

    "#{total_hours}h #{total_minutes}m"
  end
end
