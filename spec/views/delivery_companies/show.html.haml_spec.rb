require 'rails_helper'

describe "delivery_companies/show", type: :view do
  before(:each) do
    @delivery_company = assign(:delivery_company, create(:delivery_company))
  end

  it "renders attributes in <dl>" do
    render
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.name.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.url.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.form_name.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.form_action.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.field_name.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.extra_fields.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.extra_values.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.submit.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.xpath.to_s)
    assert_select 'dl>dd', text: Regexp.new(@delivery_company.css.to_s)
  end
end
