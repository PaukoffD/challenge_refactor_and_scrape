require 'rails_helper'

describe "customers/new", type: :view do
  before(:each) do
    @customer = assign(:customer, build(:customer))
  end

  it "renders new customer form" do
    render

    assert_select "form[action='#{customers_path}'][method='post']" do
      assert_select 'input#customer_name[name=?]', 'customer[name]'
    end
  end
end
