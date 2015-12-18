# == Schema Information
#
# Table name: business_accounts
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#

FactoryGirl.define do
  factory :business_account do
    customer { create :customer }
    sequence(:name) {|n| "BusinessAccount ##{n}" }
  end
end
