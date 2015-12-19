require 'rails_helper'

describe "customers/show", type: :view do
  before(:each) do
    @customer = assign(:customer, create(:customer))
  end

  it "renders attributes in <dl>" do
    render
    assert_select 'dl>dd', text: Regexp.new(@customer.name.to_s)
  end

  it 'has the link to the devices' do
    render
    assert_select 'a[href=?]', customer_devices_path(@customer)
  end
end
