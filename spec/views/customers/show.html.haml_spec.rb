require 'rails_helper'

describe "customers/show", type: :view do
  before(:each) do
    @customer = assign(:customer, create(:customer))
  end

  it "renders attributes in <dl>" do
    render
    assert_select 'dl>dd', text: Regexp.new(@customer.name.to_s)
  end

  it 'has the link to the devices in dl>dt' do
    render
    assert_select 'dl>dt>a[href=?]', customer_devices_path(@customer)
  end

  it 'has the link to the import devices in dl>dd' do
    render
    assert_select 'dl>dd>a[href=?]', new_import_customer_devices_path(@customer)
  end
end
