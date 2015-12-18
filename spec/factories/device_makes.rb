# == Schema Information
#
# Table name: device_makes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :device_make do
    sequence(:name) {|n| "DeviceMake ##{n}" }
  end
end
