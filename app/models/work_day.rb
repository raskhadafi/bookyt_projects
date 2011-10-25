class WorkDay
  attr_accessor :date, :employment

  def initialize(date, employment)
    @date       = date
    @employment = employment
  end
  
  def hours_due
    case date.wday
      when 6, 0
        0.0
      else
        employment.daily_workload
    end
  end

  def hours_worked
    employment.employee.activities.where(:date => date).to_a.sum(&:duration)
  end

  def overtime
    hours_worked - hours_due
  end
end
