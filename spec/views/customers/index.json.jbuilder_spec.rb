require 'rails_helper'

describe "customers/index.json.jbuilder", type: :view do
  before(:each) do
    @customer = create(:customer)
    assign :customers, [@customer, @customer]
  end

  attributes = %w[
    id
    name
    url
  ]

  it "renders a list of customers as json with following attributes: #{attributes.join(', ')}" do
    render

    hash = MultiJson.load rendered
    expect(hash.first).to eq(hash = hash.last)
    expect(hash.keys.sort).to eq attributes.sort
    expected = @customer.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expected['url'] = customer_url(@customer, format: 'json')
    expect(hash).to eq expected
    # expect(hash['id']).to eq @customer.id.to_s
    # expect(hash['name']).to eq @customer.name.to_s
    # expect(hash['url']).to eq customer_url(@customer, format: 'json')
  end
end
