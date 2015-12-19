json.array!(@devices) do |device|
  json.extract! device, :id, :number, :status, :imei_number, :sim_number, :model, :contract_expiry_date, :username, :location, :email, :employee_number, :contact_id, :inactive, :in_suspension, :is_roaming, :additional_data_old, :added_features, :current_rate_plan, :data_usage_status, :transfer_to_personal_status, :apple_warranty, :eligibility_date, :number_for_forwarding, :call_forwarding_status, :asset_tag
  json.url device_url(device, format: :json)
  json.business_account device.business_account.name
  json.carrier_base device.carrier_base.name
  json.device_make device.device_make.name
  json.device_model device.device_model.name
  json.customer do
    json.id device.customer.id
    json.name device.customer.name
    json.url customer_url(device.customer, format: :json)
  end
end
