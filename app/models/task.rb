class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  attr_accessor :minutes, :hours
  
  validates :project, :presence => true
  validates :person,  :presence => true
  validates :when,    :presence => true
  validates :from,    :presence => true, :unless => :hours_minutes
  validates :to,      :presence => true, :unless => :hours_minutes
  validates_numericality_of :hours,   :only_integer => true, :unless => :from
  validates_numericality_of :minutes, :only_integer => true, :unless => :from
  
  before_save :calculate_hours, :if => :hours_minutes
  
  def hours_minutes
    minutes || hours
  end
  
  def calculate_hours
    self.from = DateTime.now
    self.to = self.from + hours.to_i.hours + minutes.to_i.minutes
  end
  
  # The duration of the task in minutes
  def duration
    minutes = (to.to_f - from.to_f).to_i / 60
    
    minutes < 0 ? 1.day.to_i + minutes : minutes
  end
end
