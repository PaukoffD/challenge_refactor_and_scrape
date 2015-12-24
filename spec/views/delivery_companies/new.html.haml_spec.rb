require 'rails_helper'

describe "delivery_companies/new", type: :view do
  before(:each) do
    @delivery_company = assign(:delivery_company, build(:delivery_company))
  end

  it "renders new delivery_company form" do
    render

    assert_select "form[action='#{delivery_companies_path}'][method='post']" do
      assert_select 'input#delivery_company_name[name=?]', 'delivery_company[name]'
      assert_select 'input#delivery_company_url[name=?]', 'delivery_company[url]'
      assert_select 'input#delivery_company_form_name[name=?]', 'delivery_company[form_name]'
      assert_select 'input#delivery_company_form_action[name=?]', 'delivery_company[form_action]'
      assert_select 'input#delivery_company_field_name[name=?]', 'delivery_company[field_name]'
      assert_select 'input#delivery_company_extra_fields[name=?]', 'delivery_company[extra_fields]'
      assert_select 'input#delivery_company_extra_values[name=?]', 'delivery_company[extra_values]'
      assert_select 'input#delivery_company_submit[name=?]', 'delivery_company[submit]'
      assert_select 'input#delivery_company_xpath[name=?]', 'delivery_company[xpath]'
      assert_select 'textarea#delivery_company_css[name=?]', 'delivery_company[css]'
    end
  end
end
