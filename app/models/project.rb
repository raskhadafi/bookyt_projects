class Project < ActiveRecord::Base
  belongs_to :client, :class_name => 'Person'
  belongs_to :project_state
  has_many :activities
  
  def to_s
    name
  end
end
