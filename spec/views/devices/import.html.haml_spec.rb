require 'rails_helper'

describe "devices/import", type: :view do
  before(:each) do
    @customer = assign :customer, create(:customer)
  end

  it 'has the link to the customer' do
    render
    assert_select 'a[href=?]', customer_path(@customer)
  end

  context 'when @errors are present' do
    before :each do
      assign :errors, {
        'General' => 'A general error',
        '1236548' => ['First error for 1236548', 'Second error for 1236548'],
      }
      render
    end

    it 'renders text "General error" in dl>dt' do
      assert_select 'dl>dt', text: "General error"
    end

    it 'renders text "Errors for device # <number>" in dl>dt' do
      assert_select 'dl>dt', text: "Errors for the device # 1236548"
    end

    it 'renders the messages in dl>dd' do
      assert_select 'dl>dd', text: 'A general error'
      assert_select 'dl>dd', text: 'First error for 1236548'
      assert_select 'dl>dd', text: 'Second error for 1236548'
    end
  end   # when @errors are present

  context 'when @warnings are present' do
    before :each do
      assign :warnings, ['First warning', 'Second warning']
      render
    end

    it 'renders the messages in dl>dd' do
      assert_select 'dl>dd', text: 'First warning'
      assert_select 'dl>dd', text: 'Second warning'
    end
  end   # when @warnings are present

  it "renders the form for imporiing new devices" do
    render

    assert_select "form[action='#{import_customer_devices_path @customer}'][method='post']" do
      assert_select 'input#import_file[name=?]', 'import_file'
      assert_select 'input#clear_existing_data[name=?]', 'clear_existing_data'
      assert_select 'input[type=submit]'
    end
  end    # renders the form for imporiing new devices
end
