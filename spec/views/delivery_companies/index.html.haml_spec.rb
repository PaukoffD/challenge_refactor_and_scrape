require 'rails_helper'

describe "delivery_companies/index", type: :view do
  before(:each) do
    @delivery_company = create(:delivery_company)
    assign(:delivery_companies, DeliveryCompany.all)
  end

  it "renders a list of delivery_companies" do
    render

    assert_select 'tr>td', text: @delivery_company.name.to_s, count: 1
    assert_select 'tr>td', text: @delivery_company.url.to_s, count: 1
    assert_select 'tr>td', text: @delivery_company.form_name.to_s, count: 0
    assert_select 'tr>td', text: @delivery_company.form_action.to_s, count: 0
    assert_select 'tr>td', text: @delivery_company.field_name.to_s, count: 0
    assert_select 'tr>td', text: @delivery_company.extra_fields.to_s, count: 0
    assert_select 'tr>td', text: @delivery_company.extra_values.to_s, count: 0
    assert_select 'tr>td', text: @delivery_company.submit.to_s, count: 0
    assert_select 'tr>td', text: @delivery_company.xpath.to_s, count: 0
  end

end
