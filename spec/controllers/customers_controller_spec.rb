require 'rails_helper'

describe CustomersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well. The list could not be empty.
  let(:valid_attributes) {FactoryGirl.build(:customer).attributes.slice *%w[name]}

  let(:invalid_attributes) do
    customer = create :customer
    customer.attributes.slice *%w[name]
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CustomersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all customers as @customers" do
      customer = create :customer
      get :index, {}, valid_session
      expect(assigns(:customers)).to be_kind_of(ActiveRecord::Relation)
      expect(assigns(:customers)).to eq([customer])
    end
  end

  describe "GET show" do
    it "assigns the requested customer as @customer" do
      customer = create :customer
      get :show, {id: customer.to_param}, valid_session
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe "GET new" do
    it "assigns a new customer as @customer" do
      get :new, {}, valid_session
      expect(assigns(:customer)).to be_a_new(Customer)
    end
  end

  describe "GET edit" do
    it "assigns the requested customer as @customer" do
      customer = create :customer
      get :edit, {id: customer.to_param}, valid_session
      expect(assigns(:customer)).to eq(customer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Customer" do
        expect do
          post :create, {customer: valid_attributes}, valid_session
        end.to change(Customer, :count).by(1)
      end

      it "assigns a newly created customer as @customer" do
        post :create, {customer: valid_attributes}, valid_session
        expect(assigns(:customer)).to be_a(Customer)
        expect(assigns(:customer)).to be_persisted
      end

      it "redirects to the created customer" do
        post :create, {customer: valid_attributes}, valid_session
        expect(response).to redirect_to(Customer.last)
        # expect(response).to redirect_to(customers_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved customer as @customer" do
        # allow_any_instance_of(Customer).to receive(:save).and_return(false)
        post :create, {customer: invalid_attributes}, valid_session
        expect(assigns(:customer)).to be_a_new(Customer)
      end

      it "re-renders the 'new' template" do
        # allow_any_instance_of(Customer).to receive(:save).and_return(false)
        post :create, {customer: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end   # describe "POST create"

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { {name: 'New value'} }

      it "updates the requested customer" do
        customer = create :customer
        # expect_any_instance_of(Customer)
        #   .to receive(:update).with(new_attributes.inject({}){|_, (k, v)| _[k] = v.to_s; _})
        put :update, {id: customer.to_param, customer: new_attributes}, valid_session
        customer.reload
        # skip("Add assertions for updated state")
        expect(customer.name).to eq 'New value'
      end

      it "assigns the requested customer as @customer" do
        customer = create :customer
        put :update, {id: customer.to_param, customer: valid_attributes}, valid_session
        expect(assigns(:customer)).to eq(customer)
      end

      it "redirects to the customer" do
        customer = create :customer
        put :update, {id: customer.to_param, customer: valid_attributes}, valid_session
        expect(response).to redirect_to(customer)
      end
    end

    describe "with invalid params" do
      it "assigns the customer as @customer" do
        customer = create :customer
        # allow_any_instance_of(Customer).to receive(:update).and_return(false)
        put :update, {id: customer.to_param, customer: invalid_attributes}, valid_session
        expect(assigns(:customer)).to be_a(Customer)
      end

      it "re-renders the 'edit' template" do
        customer = create :customer
        # allow_any_instance_of(Customer).to receive(:update).and_return(false)
        put :update, {id: customer.to_param, customer: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end   # describe "PUT update"

  describe "DELETE destroy" do
    it "destroys the requested customer" do
      customer = create :customer
      expect do
        delete :destroy, {id: customer.to_param}, valid_session
      end.to change(Customer, :count).by(-1)
    end

    it "redirects to the customers list" do
      customer = create :customer
      delete :destroy, {id: customer.to_param}, valid_session
      expect(response).to redirect_to(customers_url)
    end
  end   # describe "DELETE destroy"

end
