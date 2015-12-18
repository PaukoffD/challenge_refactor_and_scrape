require 'rails_helper'

describe "customers/show.json.jbuilder", type: :view do
  before(:each) do
    @customer = assign(:customer, create(:customer))
  end

  attributes = %w[
    id
    name
    created_at
    updated_at
  ]

  it "renders the following attributes of customer: #{attributes.join(', ')} as json" do
    render

    hash = MultiJson.load rendered
    expect(hash.keys.sort).to eq attributes.sort
    expected = @customer.attributes.slice *attributes
    expected = MultiJson.load MultiJson.dump expected
    expect(hash).to eq expected
    # expect(hash['id']).to eq @customer.id.to_s
    # expect(hash['name']).to eq @customer.name.to_s
    # expect(hash['created_at']).to eq @customer.created_at.to_s
    # expect(hash['updated_at']).to eq @customer.updated_at.to_s
  end
end
