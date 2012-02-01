class WorkDay < ActiveRecord::Base
  # Associations
  belongs_to :person
  validates :person, :presence => true

  def activities
    person.activities.where(:date => date)
  end

  # Order
  default_scope order(:date)

  # String
  def to_s
    "%s %s: %s/%s" % [date, person, hours_worked, hours_due]
  end

  # Calculations
  default_scope select('work_days.*, hours_worked - hours_due AS overtime')

  def self.create_or_update(person, date)
    work_day = person.work_days.where(:date => date).first
    work_day ||= person.work_days.build(:date => date)

    work_day.update_hours

    work_day.save
  end

  def update_hours
    self.hours_due        = calculate_hours_due
    self.hours_worked     = calculate_hours_worked
  end

  def self.create_or_update_upto(person, end_date)
    # Guard
    if latest_work_day = person.work_days.last
      start_date = latest_work_day.date
    else
      start_date = end_date
    end

    (start_date..end_date).each do |date|
      transaction do
        self.create_or_update(person, date)
      end
    end
  end

  # Get employment
  #
  # Lookup the employment for this day.
  def employment
    person.employments.current(self.date)
  end

  # Get daily workload
  #
  # Lookup daily workload for person. Returns 0.0 if no
  # employment is specified.
  def daily_workload
    employment.try(:daily_workload) || 0.0
  end

  # Working hours for this day
  #
  # Saturday and sunday are off, uses daily workload for
  # all other days.
  def calculate_hours_due
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
  def calculate_hours_worked
    activities.where(:date => date).sum('duration')
  end

  # Calculate accumulated overtime
  def overall_overtime
    WorkDay.where('date <= ?', date).sum('hours_worked - hours_due')
  end
end
