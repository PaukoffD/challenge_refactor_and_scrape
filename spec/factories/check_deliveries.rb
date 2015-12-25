FactoryGirl.define do
  factory :check_delivery do
    delivery_company { create :delivery_company }
    query "MyString"
  end
end
