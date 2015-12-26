require 'rails_helper'

describe "check_deliveries/show", type: :view do
  before(:each) do
    @delivery_company = create :delivery_company
    @check_delivery = assign :check_delivery, CheckDelivery.new(delivery_company: @delivery_company)
    @reslult = assign :result, '<span>OK</span>'
  end

  it 'renders result in <div id="result_of_check_deliveries">' do
    render
    assert_select 'div#simplex_mobility_result_of_check_deliveries>span', text: 'OK'
  end

  it 'renders css in <style> in <div id="result_of_check_deliveries">' do
    render
    # expect(rendered).to eq ''
    assert_select '#simplex_mobility_result_of_check_deliveries>style',
        text: Regexp.new(@delivery_company.css)
  end
end
