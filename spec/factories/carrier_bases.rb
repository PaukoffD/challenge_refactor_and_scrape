# == Schema Information
#
# Table name: carrier_bases
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :carrier_base, :class => 'CarrierBase' do
    sequence(:name) {|n| "CarrierBase ##{n}" }
  end
end
