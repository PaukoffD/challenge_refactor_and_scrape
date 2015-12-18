# == Schema Information
#
# Table name: accounting_categories
#
#  id                 :integer          not null, primary key
#  accounting_type_id :integer
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :accounting_category do
    accounting_type { create :accounting_type }
    sequence(:name) {|n| "AccountingCategory ##{n}" }
  end
end
