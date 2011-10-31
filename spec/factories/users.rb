FactoryGirl.define do
  factory :admin_role, :class => Role do
    name 'admin'
  end
  
  factory :admin, :class => User do
    email 'test@bookyt_projects.com'
    password 'admin1234'
    association :admin_role
    person
  end
end
