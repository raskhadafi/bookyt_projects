module BookytProjects
  module Person
    extend ActiveSupport::Concern

    included do
      has_many :activities, :foreign_key => :person_id
    end
  end
end
