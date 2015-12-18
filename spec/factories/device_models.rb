# == Schema Information
#
# Table name: device_models
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :device_model do
    sequence(:name) {|n| "DeviceModel ##{n}" }
  end
end
