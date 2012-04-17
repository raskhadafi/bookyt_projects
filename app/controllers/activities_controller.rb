class ActivitiesController < AuthorizedController
  belongs_to :project, :optional => true
  belongs_to :person, :optional => true
  belongs_to :employee, :optional => true

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
    @activity.person ||= Person.find(params[:employee_id]) if params[:employee_id]
    @activity.person ||= Person.find(params[:person_id]) if params[:person_id]
    @activity.person ||= current_user.person if current_user

    # Educated guessing of project
    @activity.project_id ||= params[:project_id] if params[:project_id]
    @activity.project_id ||= @activity.person.latest_project.try(:id)

    new!
  end

  def create
    create! {
      params = {:date => @activity.date.in(1.day).to_date, :project_id => @activity.project_id}
      polymorphic_url([:new, parent, :activity].compact, :activity => params)
    }
  end
end
