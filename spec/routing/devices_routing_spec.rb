require "rails_helper"

RSpec.describe DevicesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/customers/1/devices").to route_to("devices#index", customer_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/customers/1/devices/new").to route_to("devices#new", customer_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/devices/1").to route_to("devices#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/devices/1/edit").to route_to("devices#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/customers/1/devices").to route_to("devices#create", customer_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/devices/1").to route_to("devices#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/devices/1").to route_to("devices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/devices/1").to route_to("devices#destroy", :id => "1")
    end

    it 'routes to #import via GET' do
      expect(:get => "/customers/1/devices/import").to route_to("devices#import", customer_id: '1')
    end

    it 'routes to #import via POST' do
      expect(:post => "/customers/1/devices/import").to route_to("devices#import", customer_id: '1')
    end

  end
end
