class Activity < ActiveRecord::Base
  # Associations
  belongs_to :project
  belongs_to :person
  validates :project, :presence => true, :allow_blank => false
  validates :person,  :presence => true, :allow_blank => false
  
  # Scopes
  scope :by_date, lambda {|value| where(:date => value)}
  scope :by_period, lambda {|value|
    if value.is_a? Array
      where(:date => (value[0]..value[1]))
    else
      where(:date => value)
    end
  }

  # Sorting
  default_scope order("date DESC")

  # Duration
  validates :duration, :presence => true, :format => {:with => /[0-9]{1,2}([:.][0-9]{1,2})/}

  validates_date :date, :allow_nil => false, :allow_blank => false

  def duration=(value)
    if value.match(/:/)
      hours, minutes = value.split(':')
      write_attribute(:duration, hours.to_i + BigDecimal.new(minutes) / 60)
    else
      write_attribute(:duration, value)
    end
  end

  def to_s
    "%s: %0.2fh" % [project.name, duration]
  end

  # Work day
  belongs_to :work_day, :autosave => true
  after_save :update_work_day
  after_destroy :update_work_day

  private
  def update_work_day
    WorkDay.create_or_update(self.person, date)
  end
end
