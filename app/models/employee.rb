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
    check_ins.any? && check_ins.last.check_out_time.nil?
  end

  # Returns the time self was checked in on a given date in the format:
  #  6h 36m
  #
  # @param (Date) - the date the user was checked in
  # @returns (String) - formatted time checked in
  def time_checked_in_on_date(date)
    total_hours = total_minutes = 0

    all_check_ins_on_date(date).each { |check_in| total_minutes += check_in.time_checked_in }

    if total_minutes >= 60
      # Will return how many times total_minutes goes into 60, without remainder
      total_hours = total_minutes / 60
      total_minutes -= (total_hours * 60)
    end

    "#{total_hours}h #{total_minutes}m"
  end

  # Returns the largest number of CheckIns on any day of the current week
  def max_check_ins_this_week
    week = (Date.today.at_beginning_of_week..(Date.today.at_beginning_of_week + 4)).to_a

    max_check_ins = 0

    week.each do |day|
      if all_check_ins_on_date(day).count > max_check_ins
        max_check_ins = all_check_ins_on_date(day).count
      end
    end

    max_check_ins
  end

  def all_check_ins_today
    all_check_ins_on_date(Date.today)
  end

  # Gets all CheckIns from given date, including ones where user is currently
  # checked in
  def all_check_ins_on_date(date)
    check_ins.where(
      '(check_in_time >= ? AND check_in_time <= ?) AND ' +
      '((check_out_time <= ? AND check_out_time >= ? AND check_out_time is NOT NULL) OR ' +
      '(check_out_time is NULL)) ',
      date.to_date.beginning_of_day,
      date.to_date.end_of_day,
      date.to_date.end_of_day,
      date.to_date.beginning_of_day
    ).order(:created_at).to_a
  end
end
