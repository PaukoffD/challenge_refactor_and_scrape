require 'rails_helper'

describe "devices/index", type: :view do
  before(:each) do
    @device = create(:device)
    assign(:devices, Device.all)
    @customer = assign :customer, @device.customer
  end

  it "renders a list of devices" do
    render

    assert_select 'tr>td', text: @device.number.to_s, count: 1
    assert_select 'tr>td', text: @device.customer.name, count: 1
    assert_select 'tr>td', text: @device.device_make.name, count: 1
    assert_select 'tr>td', text: @device.device_model.name, count: 1
    assert_select 'tr>td', text: @device.status.to_s, count: 1
    assert_select 'tr>td', text: @device.imei_number.to_s, count: 1
    assert_select 'tr>td', text: @device.sim_number.to_s, count: 1
    assert_select 'tr>td', text: @device.model.to_s, count: 1
    assert_select 'tr>td', text: @device.carrier_base.name, count: 1
    assert_select 'tr>td', text: @device.business_account.name, count: 1
    assert_select 'tr>td', text: @device.contract_expiry_date.to_s, count: 1
    assert_select 'tr>td', text: @device.username.to_s, count: 1
    assert_select 'tr>td', text: @device.location.to_s, count: 1
    assert_select 'tr>td', text: @device.email.to_s, count: 1
    assert_select 'tr>td', text: @device.employee_number.to_s, count: 1
    assert_select 'tr>td', text: @device.contact_id.to_s, count: 1
    assert_select 'tr>td', text: @device.inactive.to_s, count: 2
    assert_select 'tr>td', text: @device.in_suspension.to_s, count: 2
    assert_select 'tr>td', text: @device.is_roaming.to_s, count: 1
    assert_select 'tr>td', text: @device.additional_data_old.to_s, count: 10
    assert_select 'tr>td', text: @device.added_features.to_s, count: 10
    assert_select 'tr>td', text: @device.current_rate_plan.to_s, count: 10
    assert_select 'tr>td', text: @device.data_usage_status.to_s, count: 10
    assert_select 'tr>td', text: @device.transfer_to_personal_status.to_s, count: 10
    assert_select 'tr>td', text: @device.apple_warranty.to_s, count: 10
    assert_select 'tr>td', text: @device.eligibility_date.to_s, count: 10
    assert_select 'tr>td', text: @device.number_for_forwarding.to_s, count: 10
    assert_select 'tr>td', text: @device.call_forwarding_status.to_s, count: 10
    assert_select 'tr>td', text: @device.asset_tag.to_s, count: 10
  end

  it 'has the link to the customer' do
    render
    assert_select 'a[href=?]', customer_path(@customer)
  end
end
