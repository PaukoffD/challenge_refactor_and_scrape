require 'rails_helper'

describe DevicesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Device. As you add validations to Device, be sure to
  # adjust the attributes here as well. The list could not be empty.
  let(:valid_attributes) {FactoryGirl.build(:device).attributes.slice *%w[number status customer_id]}

  let(:invalid_attributes) {{number: ''}}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DevicesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all devices as @devices" do
      device = create :device
      get :index, {}, valid_session
      expect(assigns(:devices)).to be_kind_of(ActiveRecord::Relation)
      expect(assigns(:devices)).to eq([device])
    end
  end

  describe "GET show" do
    it "assigns the requested device as @device" do
      device = create :device
      get :show, {id: device.to_param}, valid_session
      expect(assigns(:device)).to eq(device)
    end
  end

  describe "GET new" do
    it "assigns a new device as @device" do
      get :new, {}, valid_session
      expect(assigns(:device)).to be_a_new(Device)
    end
  end

  describe "GET edit" do
    it "assigns the requested device as @device" do
      device = create :device
      get :edit, {id: device.to_param}, valid_session
      expect(assigns(:device)).to eq(device)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Device" do
        expect do
          post :create, {device: valid_attributes}, valid_session
        end.to change(Device, :count).by(1)
      end

      it "assigns a newly created device as @device" do
        post :create, {device: valid_attributes}, valid_session
        expect(assigns(:device)).to be_a(Device)
        expect(assigns(:device)).to be_persisted
      end

      it "redirects to the created device" do
        post :create, {device: valid_attributes}, valid_session
        expect(response).to redirect_to(Device.last)
        # expect(response).to redirect_to(devices_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved device as @device" do
        # allow_any_instance_of(Device).to receive(:save).and_return(false)
        post :create, {device: invalid_attributes}, valid_session
        expect(assigns(:device)).to be_a_new(Device)
      end

      it "re-renders the 'new' template" do
        # allow_any_instance_of(Device).to receive(:save).and_return(false)
        post :create, {device: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end   # describe "POST create"

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { {number: 'New value'} }

      it "updates the requested device" do
        device = create :device
        # expect_any_instance_of(Device)
        #   .to receive(:update).with(new_attributes.inject({}){|_, (k, v)| _[k] = v.to_s; _})
        put :update, {id: device.to_param, device: new_attributes}, valid_session
        device.reload
        # skip("Add assertions for updated state")
        expect(device.number).to eq 'New value'
      end

      it "assigns the requested device as @device" do
        device = create :device
        put :update, {id: device.to_param, device: valid_attributes}, valid_session
        expect(assigns(:device)).to eq(device)
      end

      it "redirects to the device" do
        device = create :device
        put :update, {id: device.to_param, device: valid_attributes}, valid_session
        expect(response).to redirect_to(device)
      end
    end

    describe "with invalid params" do
      it "assigns the device as @device" do
        device = create :device
        # allow_any_instance_of(Device).to receive(:update).and_return(false)
        put :update, {id: device.to_param, device: invalid_attributes}, valid_session
        expect(assigns(:device)).to be_a(Device)
      end

      it "re-renders the 'edit' template" do
        device = create :device
        # allow_any_instance_of(Device).to receive(:update).and_return(false)
        put :update, {id: device.to_param, device: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end   # describe "PUT update"

  describe "DELETE destroy" do
    it "destroys the requested device" do
      device = create :device
      expect do
        delete :destroy, {id: device.to_param}, valid_session
      end.to change(Device, :count).by(-1)
    end

    it "redirects to the devices list" do
      device = create :device
      delete :destroy, {id: device.to_param}, valid_session
      expect(response).to redirect_to(devices_url)
    end
  end   # describe "DELETE destroy"

end
