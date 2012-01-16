module TimesheetHelper
  # Calculate classes for WorkDay rows
  #
  # We add a 0.5h margin when determine over/undertime.
  # Days in the future get the 'future' class.
  def work_day_classes(day)
    # No classes for days in the future
    return 'future' if day.date > Date.today

    classes = []

    # TODO: make a setting
    # +/- 0.5h is good
    margin = 0.5

    if day.overtime > margin
      classes << 'overtime'
    elsif day.overtime < -margin
      classes << 'undertime'
    elsif day.hours_due == 0.0
      classes << 'free'
    else
      classes << 'due_hours'
    end

    classes.join(' ')
  end
end
