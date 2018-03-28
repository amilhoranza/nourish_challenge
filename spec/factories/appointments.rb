FactoryGirl.define do
  factory :appointment do
    self.when { DateTime.now + 1.day }
    note { Faker::Lorem.sentence }
    schedule
  end
end
