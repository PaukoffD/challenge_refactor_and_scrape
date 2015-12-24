require 'rails_helper'

describe "DeliveryCompanies", type: :request do

  describe "GET /delivery_companies" do
    it "works! (now write some real specs)" do
      get delivery_companies_path
      expect(response).to have_http_status(200)
    end
  end
end
