# == Schema Information
#
# Table name: business_accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :business_account do
    sequence(:name) {|n| "BusinessAccount ##{n}" }
  end
end
