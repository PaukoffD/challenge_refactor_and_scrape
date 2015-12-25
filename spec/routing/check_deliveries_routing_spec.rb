require "rails_helper"

RSpec.describe CheckDeliveriesController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/check_deliveries").to route_to("check_deliveries#new")
    end

    it "routes to #new" do
      expect(:get => "/check_delivery").to route_to("check_deliveries#new")
    end

    it "routes to #new" do
      expect(:get => "/check_deliveries/new").to route_to("check_deliveries#new")
    end

    it "routes to #create" do
      expect(:post => "/check_deliveries").to route_to("check_deliveries#create")
    end

    it "routes to #show" do
      expect(:get => "/check_deliveries/1").not_to route_to("check_deliveries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/check_deliveries/1/edit").not_to route_to("check_deliveries#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/check_deliveries/1").not_to route_to("check_deliveries#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/check_deliveries/1").not_to route_to("check_deliveries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/check_deliveries/1").not_to route_to("check_deliveries#destroy", :id => "1")
    end

  end
end
