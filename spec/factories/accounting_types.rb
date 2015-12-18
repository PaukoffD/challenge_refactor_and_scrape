# == Schema Information
#
# Table name: accounting_types
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :accounting_type do
    customer { create :customer }
    sequence(:name) {|n| "AccountingType ##{n}" }
  end
end
