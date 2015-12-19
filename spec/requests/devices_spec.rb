require 'rails_helper'

describe "Devices", type: :request do
  describe "GET /devices" do
    it "works! (now write some real specs)" do
      customer = create :customer
      get customer_devices_path customer
      expect(response).to have_http_status(200)
    end
  end
end
