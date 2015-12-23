# == Schema Information
#
# Table name: devices
#
#  id                          :integer          not null, primary key
#  number                      :string
#  customer_id                 :integer
#  device_make_id              :integer
#  device_model_id             :integer
#  status                      :string
#  imei_number                 :string
#  sim_number                  :string
#  model                       :string
#  carrier_base_id             :integer
#  business_account_id         :integer
#  contract_expiry_date        :date
#  username                    :string
#  location                    :string
#  email                       :string
#  employee_number             :string
#  contact_id                  :string
#  inactive                    :boolean
#  in_suspension               :boolean
#  is_roaming                  :boolean
#  additional_data_old         :string
#  added_features              :string
#  current_rate_plan           :string
#  data_usage_status           :string
#  transfer_to_personal_status :string
#  apple_warranty              :string
#  eligibility_date            :string
#  number_for_forwarding       :string
#  call_forwarding_status      :string
#  asset_tag                   :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  created_by                  :string
#  source                      :string
#

FactoryGirl.define do
  factory :device do
    sequence(:number) {|n| rand(100000..999999).to_s + format('%02d', n)}
    customer { create :customer }
    device_make { create :device_make }
    device_model { create :device_model }
    status "active"
    imei_number {rand(100000000..999999999).to_s}
    sim_number {rand(10000000..99999999).to_s}
    model "Model"
    carrier_base { create :carrier_base }
    business_account { create :business_account }
    contract_expiry_date Date.current + 1.month
    sequence(:username) {|n| "username##{n}" }
    sequence(:location) {|n| "location##{n}" }
    sequence(:email) {|n| "email#{n}@gmail.com" }
    employee_number {rand(100..999)}
    contact_id {rand(1000..9999)}
    inactive false
    in_suspension false
    is_roaming true
    sequence(:created_by) {|n| "Created by ##{n}"}
    sequence(:source) {|n| "Source ##{n}"}
    additional_data_old "MyString"
    added_features "MyString"
    current_rate_plan "MyString"
    data_usage_status "MyString"
    transfer_to_personal_status "MyString"
    apple_warranty "MyString"
    eligibility_date "MyString"
    number_for_forwarding "MyString"
    call_forwarding_status "MyString"
    asset_tag "MyString"
  end
end
