require "rails_helper"

RSpec.describe DeliveryCompaniesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/delivery_companies").to route_to("delivery_companies#index")
    end

    it "routes to #new" do
      expect(:get => "/delivery_companies/new").to route_to("delivery_companies#new")
    end

    it "routes to #show" do
      expect(:get => "/delivery_companies/1").to route_to("delivery_companies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/delivery_companies/1/edit").to route_to("delivery_companies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/delivery_companies").to route_to("delivery_companies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/delivery_companies/1").to route_to("delivery_companies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/delivery_companies/1").to route_to("delivery_companies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/delivery_companies/1").to route_to("delivery_companies#destroy", :id => "1")
    end

  end
end
