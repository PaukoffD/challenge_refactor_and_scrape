require 'rails_helper'

describe "delivery_companies/index.json.jbuilder", type: :view do
  before(:each) do
    @delivery_company = create(:delivery_company)
    assign :delivery_companies, [@delivery_company, @delivery_company]
  end

  attributes = %w[
    id
    name
    url
    form_name
    form_action
    field_name
    extra_fields
    extra_values
    submit
    xpath
    css
    item_url
  ]

  it "renders a list of delivery_companies as json with following attributes: #{attributes.join(', ')}" do
    render

    hash = MultiJson.load rendered
    expect(hash.first).to eq(hash = hash.last)
    expect(hash.keys.sort).to eq attributes.sort
    expected = @delivery_company.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['item_url'] = delivery_company_url(@delivery_company, format: 'json')
    expect(hash).to eq expected
  end
end
