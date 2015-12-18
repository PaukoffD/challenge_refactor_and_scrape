FactoryGirl.define do
  factory :accounting_type do
    customer { create :customer }
    sequence(:name) {|n| "AccountingType ##{n}" }
  end
end
