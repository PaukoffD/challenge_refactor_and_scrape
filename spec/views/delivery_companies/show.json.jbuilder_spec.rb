require 'rails_helper'

describe "delivery_companies/show.json.jbuilder", type: :view do
  before(:each) do
    @delivery_company = assign(:delivery_company, create(:delivery_company))
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
    created_at
    updated_at
  ]

  it "renders the following attributes of delivery_company: #{attributes.join(', ')} as json" do
    render

    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = @delivery_company.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expect(hash).to eq expected
  end
end
