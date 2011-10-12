FactoryGirl.define do
  factory :two_hour_work, :class => Activity do |w|
    w.when = Date.today
    w.from = '08:00'
    w.to = '10:00'
    w.comment = "Two hour work"
    w.association :worker
  end
end
