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
    before :each do
      @device = create :device
    end

    it 'assigns the Customer with customer_id to @customer' do
      get :index, {customer_id: @device.customer_id}, valid_session
      expect(assigns(:customer)).to eq(@device.customer)
    end

    it "assigns all devices as @devices" do
      get :index, {customer_id: @device.customer_id}, valid_session
      expect(assigns(:devices)).to be_kind_of(ActiveRecord::Relation)
      expect(assigns(:devices)).to eq([@device])
    end
  end   # GET index

  describe "GET show" do
    before :each do
      @device = create :device
    end

    it "assigns the requested device as @device" do
      get :show, {id: @device.to_param}, valid_session
      expect(assigns(:device)).to eq(@device)
    end

    it 'assigns the requested device.customer to @customer' do
      get :show, {id: @device.to_param}, valid_session
      expect(assigns(:customer)).to eq(@device.customer)
    end
  end   # GET show

  describe "GET new" do
    before :each do
      @customer = create :customer
    end

    it 'assigns the Customer with customer_id to @customer' do
      get :new, {customer_id: @customer.id}, valid_session
      expect(assigns(:customer)).to eq(@customer)
    end

    it "assigns a new device as @device" do
      get :new, {customer_id: @customer.id}, valid_session
      expect(assigns(:device)).to be_a_new(Device)
    end
  end   # GET new

  describe "GET edit" do
    before :each do
      @device = create :device
    end

    it 'assigns the requested device.customer to @customer' do
      get :edit, {id: @device.to_param}, valid_session
      expect(assigns(:customer)).to eq(@device.customer)
    end

    it "assigns the requested device as @device" do
      get :edit, {id: @device.to_param}, valid_session
      expect(assigns(:device)).to eq(@device)
    end
  end   # GET edit

  describe "POST create" do
    before :each do
      @customer = create :customer
    end

    it 'assigns the Customer with customer_id to @customer' do
      post :create, {customer_id: @customer.id, device: valid_attributes}, valid_session
      expect(assigns(:customer)).to eq(@customer)
    end

    describe "with valid params" do
      it "creates a new Device" do
        expect do
          post :create, {customer_id: @customer.id, device: valid_attributes}, valid_session
        end.to change(Device, :count).by(1)
      end

      it "assigns a newly created device as @device" do
        post :create, {customer_id: @customer.id, device: valid_attributes}, valid_session
        expect(assigns(:device)).to be_a(Device)
        expect(assigns(:device)).to be_persisted
      end

      it "redirects to the created device" do
        post :create, {customer_id: @customer.id, device: valid_attributes}, valid_session
        expect(response).to redirect_to(Device.last)
        # expect(response).to redirect_to(devices_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved device as @device" do
        # allow_any_instance_of(Device).to receive(:save).and_return(false)
        post :create, {customer_id: @customer.id, device: invalid_attributes}, valid_session
        expect(assigns(:device)).to be_a_new(Device)
      end

      it "re-renders the 'new' template" do
        # allow_any_instance_of(Device).to receive(:save).and_return(false)
        post :create, {customer_id: @customer.id, device: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end   # describe "POST create"

  describe "PUT update" do
    before :each do
      @device = create :device
    end

    let(:new_attributes) { {number: 'New value'} }

    it 'assigns the requested device.customer to @customer' do
      put :update, {id: @device.to_param, device: new_attributes}, valid_session
        @device.reload
      expect(assigns(:customer)).to eq(@device.customer)
    end

    describe "with valid params" do

      it "updates the requested device" do
        put :update, {id: @device.to_param, device: new_attributes}, valid_session
        @device.reload
        expect(@device.number).to eq 'New value'
      end

      it "assigns the requested device as @device" do
        put :update, {id: @device.to_param, device: valid_attributes}, valid_session
        expect(assigns(:device)).to eq(@device)
      end

      it "redirects to the device" do
        put :update, {id: @device.to_param, device: valid_attributes}, valid_session
        expect(response).to redirect_to(@device)
      end
    end

    describe "with invalid params" do
      it "assigns the device as @device" do
        put :update, {id: @device.to_param, device: invalid_attributes}, valid_session
        expect(assigns(:device)).to be_a(Device)
      end

      it "re-renders the 'edit' template" do
        put :update, {id: @device.to_param, device: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end   # describe "PUT update"

  describe "DELETE destroy" do
    before :each do
      @device = create :device
    end

    it 'assigns the requested device.customer to @customer' do
      delete :destroy, {id: @device.to_param}, valid_session
      expect(assigns(:customer)).to eq(@device.customer)
    end

    it "destroys the requested device" do
      expect do
        delete :destroy, {id: @device.to_param}, valid_session
      end.to change(Device, :count).by(-1)
    end

    it "redirects to the device.customer" do
      delete :destroy, {id: @device.to_param}, valid_session
      expect(response).to redirect_to(customer_devices_url @device.customer)
    end
  end   # describe "DELETE destroy"

end
