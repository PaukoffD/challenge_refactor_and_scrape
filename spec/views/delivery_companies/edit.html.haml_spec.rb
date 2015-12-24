require 'rails_helper'

describe "delivery_companies/edit", type: :view do
  before(:each) do
    @delivery_company = assign(:delivery_company, create(:delivery_company))
  end

  it "renders the edit delivery_company form" do
    render

    assert_select "form[action='#{delivery_company_path(@delivery_company)}'][method='post']" do
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
