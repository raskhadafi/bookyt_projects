class WorkDay
  attr_accessor :date, :employee

  def initialize(employee, date)
    @date     = date
    @employee = employee
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
    range.to_a.map{|day| WorkDay.new(employee, day)}
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

  # Helper to access daily workload
  #
  # Returns 0.0 if no current daily_workload can be determined
  def daily_workload
    # Guard
    return 0.0 unless employee && employee.employments.current && employee.employments.current.daily_workload

    employee.employments.current.daily_workload
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
    employee.activities.where(:date => date).to_a.sum(&:duration)
  end

  # Overtime
  #
  # Simply substract hours_due from hours_worked.
  def overtime
    hours_worked - hours_due
  end
end
