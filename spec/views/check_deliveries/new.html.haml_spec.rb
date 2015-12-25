require 'rails_helper'

describe "check_deliveries/new", type: :view do
  before(:each) do
    @check_delivery = assign(:check_delivery, CheckDelivery.new)
  end

  it "renders new check_delivery form" do
    render

    assert_select "form[action='#{check_deliveries_path}'][method='post']" do
      assert_select 'select#check_delivery_delivery_company_id[name=?]', 'check_delivery[delivery_company_id]'
      assert_select 'input#check_delivery_query[name=?]', 'check_delivery[query]'
    end
  end
end
