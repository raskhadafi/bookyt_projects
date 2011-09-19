class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  validates :project, :presence => true
  validates :person,  :presence => true
  validates :when,    :presence => true
  validates :from,    :presence => true
  validates :to,      :presence => true
  
  # The duration of the task in minutes
  def duration
    minutes = (to.to_f - from.to_f).to_i / 60
    
    minutes < 0 ? 1.day.to_i + minutes : minutes
  end
end
