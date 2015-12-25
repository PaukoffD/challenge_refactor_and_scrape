require 'rails_helper'

describe "CheckDeliveries", type: :request do
  describe "GET /check_deliveries" do
    it "works! (now write some real specs)" do
      get check_deliveries_path
      expect(response).to have_http_status(200)
    end
  end
end
