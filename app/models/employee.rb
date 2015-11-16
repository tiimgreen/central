class Employee < ActiveRecord::Base
  include HolidaysHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Rails relation that links the CheckIn model to Employees
  has_many :check_ins
  has_many :sick_days
  has_many :holiday_requests

  # Validations
  validates :email,                          presence: true
  validates :first_name,                     presence: true
  validates :last_name,                      presence: true
  validates :job_title,                      presence: true
  validates :start_date,                     presence: true
  validates :is_line_manager,                presence: true
  validates :contracted_hours,               presence: true
  validates :emergency_contact_name,         presence: true
  validates :emergency_contact_relation,     presence: true
  validates :emergency_contact_phone_number, presence: true

  # Build in rails method that specifies how the parameter for the Model will
  # appear in URLs e.g.:
  #
  #   /employees/1-tim-green
  #
  # @returns (String) - URL parameter
  def to_param
    [id, full_name.parameterize].join('-')
  end

  # Returns full name of employee
  #
  # @returns (String) - full name
  def full_name
    "#{first_name} #{last_name}"
  end

  # More readable method to return the active value
  #
  # @returns (Boolean) - Employee.active
  def is_active?
    active
  end

  # Returns an Employee model of the line manager of self.
  #
  # @returns (Employee) - the line manager of self, if one is set
  def line_manager
    line_manager_id.nil? ? nil : Employee.find(line_manager_id)
  end

  def subordinates
    Employee.where(line_manager_id: id)
  end

  # Is self checked in currently
  #
  # @returns (Boolean)
  def checked_in?
    check_ins.any? && check_ins.order(:check_in_time).last.check_out_time.nil?
  end

  # Returns the total minutes checked in on date
  #
  # @param (Date) - the date the user was checked in
  # @returns (Integer) - total minutes checked in on date
  def minutes_checked_in_on_date(date)
    total_hours = total_minutes = 0

    all_check_ins_on_date(date).each { |check_in| total_minutes += check_in.time_checked_in }

    total_minutes
  end

  # Returns the time self was checked in on a given date in the format:
  #  6h 36m
  #
  # @param (Date) - the date the user was checked in
  # @returns (String) - formatted time checked in
  def formatted_time_checked_in_on_date(date)
    total_minutes = minutes_checked_in_on_date(date)
    format_minutes(total_minutes)
  end

  # Returns the time self was checked in for whole week:
  #  6h 36m
  #
  # @param (Date) - start of week
  # @returns (String) - formatted time checked in for week
  def formatted_time_checked_in_on_week(date)
    week = (date..(date + 4)).to_a
    total_minutes = 0

    week.each { |day| total_minutes += minutes_checked_in_on_date(day) }

    format_minutes(total_minutes)
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

      if max_check_ins == 0
        max_check_ins = 1 if sick_day?(day) || CompanyHoliday.is_holiday?(day)
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

  # Does self have any check-ins on the week starting on the given date
  #
  # @returns (Boolean)
  def has_check_ins_on_week?(date)
    first_day = date.at_beginning_of_week
    current_week = (first_day..(first_day + 4)).to_a
    current_week.each { |day| return true if all_check_ins_on_date(day).any? }
    false
  end

  def can_view_next_week?(start_of_current_week)
    has_check_ins_on_week?(start_of_current_week + 7.days) ||
    start_of_current_week + 7.days <= Date.today
  end

  def can_view_previous_week?(start_of_current_week)
    has_check_ins_on_week?(start_of_current_week - 7.days) ||
    start_date <= start_of_current_week - 3.days
  end

  # Calculates the amount of holiday days per year the employee gets
  #
  # @returns (Integer)
  def allocated_holiday_days
    standard_number_of_days = 25

    # for every year, add another day, up to 35 days
    years_at_company = Time.now.year - start_date.year

    return 35 if standard_number_of_days + years_at_company >= 35

    standard_number_of_days + years_at_company
  end

  # Calculates the remaining holiday days the employee has this year
  #
  # @returns (Integer)
  def remaining_holiday_days
    count = 0

    approved_holiday_requests.each do |request|
      count += request.employee_holidays.count
    end

    allocated_holiday_days - count
  end

  # Calculates whether the employee can mark the given day as a sick day
  #
  # @returns (Boolean)
  def can_mark_as_sick_day?(day)
    Date.today >= day &&
    !sick_day?(day) &&
    !is_company_holiday?(day) &&
    !all_check_ins_on_date(day).any?
  end

  # Is the given day a sick day?
  #
  # @returns (Boolean)
  def sick_day?(date)
    sick_days.where(date: date).any?
  end

  # Returns all holiday requests that have not been approved
  #
  # @returns (ActiveRecord::Relation)
  def unapproved_holiday_requests
    holiday_requests.where(authorised: false)
  end

  # Returns all holiday requests that have been approved
  #
  # @returns (ActiveRecord::Relation)
  def approved_holiday_requests
    holiday_requests.where(authorised: true)
  end

  def pending_subordinate_holiday_requests
    requests = []

    subordinates.each do |subordinate|
      if (pending_requests = subordinate.holiday_requests.where(authorised: false).to_a).count > 0
        requests << pending_requests
      end
    end

    requests
  end

  def has_enough_holiday_left?(date_range)
    calculate_holidays_used(date_range) <= remaining_holiday_days
  end

  def is_allowed_date_off?(date)
    !is_weekend?(date) &&
    !is_company_holiday?(date) &&
    !will_be_understaffed?(self, date)
  end

  private

    def format_minutes(minutes)
      total_hours = 0

      if minutes >= 60 # if longer than or equal to an hour
        total_hours = minutes / 60 # how many times minutes goes into 60, without remainder
        minutes -= (total_hours * 60) # remaining minutes
      end

      "#{total_hours}h #{minutes}m"
    end

    def calculate_holidays_used(date_range)
      holidays_used = 0

      parse_date_range(date_range).each do |date|
        holidays_used += 1 if is_allowed_date_off?(date)
      end

      holidays_used
    end
end
