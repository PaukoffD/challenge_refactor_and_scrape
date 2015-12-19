require 'rails_helper'

describe "devices/show", type: :view do
  before(:each) do
    @device = assign(:device, create(:device))
    assign :customer, @device.customer
  end

  it "renders attributes in <dl>" do
    render
    assert_select 'dl>dd', text: Regexp.new(@device.number.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.customer.name)
    assert_select 'dl>dd', text: Regexp.new(@device.device_make.name)
    assert_select 'dl>dd', text: Regexp.new(@device.device_model.name)
    assert_select 'dl>dd', text: Regexp.new(@device.status.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.imei_number.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.sim_number.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.model.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.carrier_base.name)
    assert_select 'dl>dd', text: Regexp.new(@device.business_account.name)
    assert_select 'dl>dd', text: Regexp.new(@device.contract_expiry_date.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.username.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.location.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.email.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.employee_number.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.contact_id.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.inactive.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.in_suspension.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.is_roaming.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.additional_data_old.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.added_features.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.current_rate_plan.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.data_usage_status.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.transfer_to_personal_status.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.apple_warranty.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.eligibility_date.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.number_for_forwarding.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.call_forwarding_status.to_s)
    assert_select 'dl>dd', text: Regexp.new(@device.asset_tag.to_s)
  end
end
