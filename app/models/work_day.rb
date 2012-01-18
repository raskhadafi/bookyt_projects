class WorkDay < ActiveRecord::Base

  belongs_to :person
  has_many :activities

  before_create :current_daily_workload

  def current_daily_workload
    unless person && person.employments.current && person.employments.current.daily_workload
      self.daily_workload = 0.0
    else
      self.daily_workload = person.employments.current(self.date).daily_workload
    end
  end

  def self.create_for_current_employment(employee)
    if employee.employments.current
      range = employee.employments.current.duration_from..Date.today
      range.each do |date|
        WorkDay.create(:person => employee, :date => date)
      end
    end
  end

  # Get WorkDay instances for a range
  #
  # Returns an array of WorkDay instances. You probably want
  # to feed it a first day of month kind of starting_date.
  #
  # params:
  #   :employee: Employee to build WorkDay instances for
  #   :range:    Date range giving first and last day
  def self.for_range(employee, range)
    self.create_for_current_employment(employee)

    range.inject([]) do |out, day|
      work_day = WorkDay.where(:person_id => employee.id, :date => day).first
      work_day ||= WorkDay.create(:person => employee, :date => day)
      out << work_day

      out
    end
  end

  # Get WorkDay instances for a month
  #
  # params:
  #   :employee:      Employee to build WorkDay instances for
  #   :date_in_month: Any day in the requested month. Uses today by default.
  def self.for_month(employee, date_in_month = nil)
    # Assume today if no date given
    date_in_month ||= Date.today

    start_date = date_in_month.beginning_of_month
    end_date   = date_in_month.end_of_month

    self.for_range(employee, start_date..end_date)
  end

  # Working hours for this day
  def hours_due
    case date.wday
      when 6, 0
        # Saturday and sunday are off
        0.0
      else
        # Assume same working hours during the week
        daily_workload
    end
  end

  # Hours worked
  #
  # Calculates hours worked by summing up duration of all logged
  # activities.
  def hours_worked
    activities.where(:date => date).to_a.sum(&:duration)
  end

  # Overtime
  #
  # Simply substract hours_due from hours_worked.
  def overtime
    hours_worked - hours_due
  end

  def overall_overtime
    WorkDay.where(:person_id => person.id).where('date <= ?', date).to_a.sum(&:overtime)
  end
end
