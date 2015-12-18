FactoryGirl.define do
  factory :device_model do
    sequence(:name) {|n| "DeviceModel ##{n}" }
  end
end
