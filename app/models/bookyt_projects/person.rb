module BookytProjects
  module Person
    extend ActiveSupport::Concern

    included do
      has_many :activities, :foreign_key => :person_id
    end

    module InstanceMethods
      def latest_project
        activities.order(:duration_to).last.project
      end
    end
  end
end
