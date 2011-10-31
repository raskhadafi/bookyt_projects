require 'spec_helper'

describe ActivitiesController do
  render_views
  
  login_admin
  
  #it { should inherit_from(AuthorizedController) }
    
  it "should show a new activity" do
    get :new
    
    response.should be_success
    assigns[:activity][:date].should equal(Date.today)
  end
end
