require 'rails_helper'

describe "devices/show.json.jbuilder", type: :view do
  before(:each) do
    @device = assign(:device, create(:device))
  end

  attributes = %w[
    id
    number
    customer
    device_make
    device_model
    status
    imei_number
    sim_number
    model
    carrier_base
    business_account
    contract_expiry_date
    username
    location
    email
    employee_number
    contact_id
    inactive
    in_suspension
    is_roaming
    additional_data_old
    added_features
    current_rate_plan
    data_usage_status
    transfer_to_personal_status
    apple_warranty
    eligibility_date
    number_for_forwarding
    call_forwarding_status
    asset_tag
    created_at
    updated_at
  ]

  it "renders the following attributes of device: #{attributes.join(', ')} as json" do
    render

    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = @device.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['business_account'] = @device.business_account.name
    expected['carrier_base'] = @device.carrier_base.name
    expected['customer'] = @device.customer.name
    expected['device_make'] = @device.device_make.name
    expected['device_model'] = @device.device_model.name
    expected['customer'] =
        {
          'id' => @device.customer.id,
          'name' => @device.customer.name,
          'url' => customer_url(@device.customer, format: :json)
        }
    expect(hash).to eq expected
  end
end
