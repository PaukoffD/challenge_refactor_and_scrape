require 'rails_helper'

describe "devices/edit", type: :view do
  before(:each) do
    @device = assign(:device, create(:device))
    assign :customer, @device.customer
  end

  it "renders the edit device form" do
    render

    assert_select "form[action='#{device_path(@device)}'][method='post']" do
      assert_select 'input#device_number[name=?]', 'device[number]'
      assert_select 'select#device_customer_id[name=?]', 'device[customer_id]', count: 0
      assert_select 'select#device_device_make_id[name=?]', 'device[device_make_id]'
      assert_select 'select#device_device_model_id[name=?]', 'device[device_model_id]'
      assert_select 'input#device_status[name=?]', 'device[status]'
      assert_select 'input#device_imei_number[name=?]', 'device[imei_number]'
      assert_select 'input#device_sim_number[name=?]', 'device[sim_number]'
      assert_select 'input#device_model[name=?]', 'device[model]'
      assert_select 'select#device_carrier_base_id[name=?]', 'device[carrier_base_id]'
      assert_select 'select#device_business_account_id[name=?]', 'device[business_account_id]'
      assert_select 'input#device_username[name=?]', 'device[username]'
      assert_select 'input#device_location[name=?]', 'device[location]'
      assert_select 'input#device_email[name=?]', 'device[email]'
      assert_select 'input#device_employee_number[name=?]', 'device[employee_number]'
      assert_select 'input#device_contact_id[name=?]', 'device[contact_id]'
      assert_select 'input#device_inactive[name=?]', 'device[inactive]'
      assert_select 'input#device_in_suspension[name=?]', 'device[in_suspension]'
      assert_select 'input#device_is_roaming[name=?]', 'device[is_roaming]'
      assert_select 'input#device_additional_data_old[name=?]', 'device[additional_data_old]'
      assert_select 'input#device_added_features[name=?]', 'device[added_features]'
      assert_select 'input#device_current_rate_plan[name=?]', 'device[current_rate_plan]'
      assert_select 'input#device_data_usage_status[name=?]', 'device[data_usage_status]'
      assert_select 'input#device_transfer_to_personal_status[name=?]', 'device[transfer_to_personal_status]'
      assert_select 'input#device_apple_warranty[name=?]', 'device[apple_warranty]'
      assert_select 'input#device_eligibility_date[name=?]', 'device[eligibility_date]'
      assert_select 'input#device_number_for_forwarding[name=?]', 'device[number_for_forwarding]'
      assert_select 'input#device_call_forwarding_status[name=?]', 'device[call_forwarding_status]'
      assert_select 'input#device_asset_tag[name=?]', 'device[asset_tag]'
    end
  end
end
