class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  def duration
    "2h"
  end
end
