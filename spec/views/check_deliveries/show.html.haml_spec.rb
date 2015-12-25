require 'rails_helper'

describe "check_deliveries/show", type: :view do
  before(:each) do
    @check_delivery = assign :check_delivery, CheckDelivery.new
    @reslult = assign :result, '<span>OK</span>'
  end

  it "renders result in <div id='result'>" do
    render

    assert_select 'div#result>span', text: 'OK'
  end
end
