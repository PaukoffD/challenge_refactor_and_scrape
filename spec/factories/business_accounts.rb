FactoryGirl.define do
  factory :business_account do
    sequence(:name) {|n| "BusinessAccount ##{n}" }
  end
end
