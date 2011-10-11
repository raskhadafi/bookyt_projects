class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  attr_accessor :minutes, :hours
  
  validates :project, :presence => true, :allow_blank => false
  validates :person,  :presence => true, :allow_blank => false
  validates_date :when, :allow_nil => false, :allow_blank => false
  validates :from,    :presence => true, :unless => :hours_minutes
  validates :to,      :presence => true, :unless => :hours_minutes
  validates_numericality_of :hours,   :only_integer => true, :unless => :from
  validates_numericality_of :minutes, :only_integer => true, :unless => :from
  
  before_save :calculate_hours
  
  def hours_minutes
    minutes || hours
  end
  
  def calculate_hours
    unless hours.empty? or minutes.empty?
      self.from = DateTime.now
      self.to = self.from + hours.to_i.hours + minutes.to_i.minutes
    end
  end
  
  # The duration of the task in minutes
  def duration
    minutes = (to.to_f - from.to_f).to_i / 60
    
    minutes < 0 ? 1.day.to_i + minutes : minutes
  end

  def to_s
    "#{duration} => #{person}"
  end
end
