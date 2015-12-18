FactoryGirl.define do
  factory :device_make do
    sequence(:name) {|n| "DeviceMake ##{n}" }
  end
end
