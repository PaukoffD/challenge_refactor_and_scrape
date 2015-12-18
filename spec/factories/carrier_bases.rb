FactoryGirl.define do
  factory :carrier_base, :class => 'CarrierBase' do
    sequence(:name) {|n| "CarrierBase ##{n}" }
  end
end
