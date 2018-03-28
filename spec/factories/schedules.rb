FactoryGirl.define do
  factory :schedule do
    starting_on { DateTime.now }
    ending_on { Faker::Date::forward }
    note { Faker::Lorem.sentence }
    interval 2
    user
  end
end
