require 'rails_helper'

describe "customers/edit", type: :view do
  before(:each) do
    @customer = assign(:customer, create(:customer))
  end

  it "renders the edit customer form" do
    render

    assert_select "form[action='#{customer_path(@customer)}'][method='post']" do
      assert_select 'input#customer_name[name=?]', 'customer[name]'
    end
  end
end
