class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  validates :project,  :presence => true
  validates :person,  :presence => true
  validates :when,  :presence => true
  validates :from,  :presence => true
  validates :to,  :presence => true
  
  # The duration of the task in minutes
  def duration
    (to.to_f - from.to_f).to_i / 60
  end
end
