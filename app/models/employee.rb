class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Rails relation that links the CheckIn model to Employees
  has_many :check_ins

  def full_name
    "#{first_name} #{last_name}"
  end

  # Is self checked in currently
  #
  # @returns (Boolean)
  def checked_in?
    check_ins.any? && check_ins.order(:check_in_time).last.check_out_time.nil?
  end

  # Returns the time self was checked in on a given date in the format:
  #  6h 36m
  #
  # @param (Date) - the date the user was checked in
  # @returns (String) - formatted time checked in
  def time_checked_in_on_date(date)
    total_hours = total_minutes = 0

    all_check_ins_on_date(date).each { |check_in| total_minutes += check_in.time_checked_in }

    if total_minutes >= 60 # if longer than or equal to an hour
      total_hours = total_minutes / 60 # how many times total_minutes goes into 60, without remainder
      total_minutes -= (total_hours * 60) # remaining minutes
    end

    "#{total_hours}h #{total_minutes}m"
  end

  # Returns the largest number of CheckIns on any day of the current week
  #
  # @param (Date) - date of first day of the week
  # @returns (Integer) - on any given day of week, max number of check-ins
  def max_check_ins_on_week_starting(date)
    week = (date..(date + 4)).to_a

    max_check_ins = 0

    # loops over each day to find day with most check-ins
    week.each do |day|
      if all_check_ins_on_date(day).count > max_check_ins
        max_check_ins = all_check_ins_on_date(day).count
      end
    end

    max_check_ins
  end

  # Gets all CheckIns today
  def all_check_ins_today
    all_check_ins_on_date(Date.today)
  end

  # Gets all CheckIns from given date, including ones where user is currently
  # checked in
  #
  # @param (Date) - date of check-ins
  # @returns (Array) - array containing check-in models
  def all_check_ins_on_date(date)
    check_ins.where(
      # strings concatenated to make more readable and ensures it doesn't go off the page
      '(check_in_time >= ? AND check_in_time <= ?) AND ' +
      '((check_out_time <= ? AND check_out_time >= ? AND check_out_time is NOT NULL) OR ' +
      '(check_out_time is NULL)) ',
      date.to_date.beginning_of_day,
      date.to_date.end_of_day,
      date.to_date.end_of_day,
      date.to_date.beginning_of_day
    ).order(:check_in_time).to_a
  end
end
