class Activity < ActiveRecord::Base
  # Associations
  belongs_to :project
  belongs_to :person
  belongs_to :work_day
  validates :project, :presence => true, :allow_blank => false
  validates :person,  :presence => true, :allow_blank => false
  
  # Scopes
  scope :by_date, lambda {|value| where(:date => value)}

  # Duration
  validates :duration, :presence => true, :format => {:with => /[0-9]{1,2}([:.][0-9]{1,2})/}

  validates_date :date, :allow_nil => false, :allow_blank => false

  before_save :create_work_day

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

  private

  def create_work_day
    work_day = WorkDay.where(:person_id => person_id, :date => date).first
    work_day ||= WorkDay.create(:person_id => person_id, :date => date)

    self.work_day = work_day
  end
end
