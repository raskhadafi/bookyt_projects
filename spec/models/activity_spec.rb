require 'spec_helper'

describe Activity, :type => :model do
  it { should belong_to :project }
  it { should belong_to :person }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:person) }

  context "when new" do
  end
end
