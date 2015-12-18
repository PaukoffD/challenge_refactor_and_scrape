require 'rails_helper'

describe "customers/index", type: :view do
  before(:each) do
    @customer = create(:customer)
    assign(:customers, Customer.all)
  end

  it "renders a list of customers" do
    render

    assert_select 'tr>td', text: @customer.name.to_s, count: 1
  end

end
