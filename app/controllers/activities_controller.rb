class ActivitiesController < AuthorizedController
  belongs_to :project, :optional => true
  belongs_to :person, :optional => true

  has_scope :by_date
  has_scope :by_period, :using => [:from, :to]
  has_scope :by_project_id

  def new
    # Allow callers specifying defaults
    if params[:activity]
      @activity = Activity.new(params[:activity])
    else
      @activity = Activity.new(:date => Date.today)
    end

    # Educated guessing of person
    @activity.person ||= current_user.person if current_user

    # Educated guessing of project
    @activity.project_id ||= params[:project_id] if params[:project_id]
    @activity.project_id ||= @activity.person.latest_project.try(:id)

    new!
  end

  def create
    create! {
      polymorphic_url([:new, parent, :activity].compact)
    }
  end
end
