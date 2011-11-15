class Activity < ActiveRecord::Base
  # Associations
  belongs_to :project
  belongs_to :person
  validates :project, :presence => true, :allow_blank => false
  validates :person,  :presence => true, :allow_blank => false
  
  # Scopes
  scope :by_date, lambda {|value| where(:date => value)}

  # Duration
  attr_accessor :minutes, :hours

  validates_date :date, :allow_nil => false, :allow_blank => false
  validates :duration_from,    :presence => true, :unless => :hours_minutes
  validates :duration_to,      :presence => true, :unless => :hours_minutes
  validates_numericality_of :hours,   :only_integer => true, :unless => :duration_from
  validates_numericality_of :minutes, :only_integer => true, :unless => :duration_from
  
  before_save :calculate_hours
  
  def hours_minutes
    minutes || hours
  end
  
  def calculate_hours
    unless hours.empty? or minutes.empty?
      self.duration_from = DateTime.now
      self.duration_to = self.duration_from + hours.to_i.hours + minutes.to_i.minutes
    end
  end
  
  # The duration of the task in minutes
  def duration
    minutes = (duration_to.to_f - duration_from.to_f).to_i / 60
    
    minutes < 0 ? 1.day.to_i + minutes : minutes
  end

  def to_s
    "#{duration} => #{person}"
  end
end
