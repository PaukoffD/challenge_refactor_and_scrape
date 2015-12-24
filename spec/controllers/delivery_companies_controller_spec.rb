require 'rails_helper'

describe DeliveryCompaniesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # DeliveryCompany. As you add validations to DeliveryCompany, be sure to
  # adjust the attributes here as well. The list could not be empty.
  let(:valid_attributes) {FactoryGirl.build(:delivery_company).attributes.slice *%w[name url form_name field_name submit xpath]}

  let(:invalid_attributes) do
    {url: ''}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DeliveryCompaniesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all delivery_companies as @delivery_companies" do
      delivery_company = create :delivery_company
      get :index, {}, valid_session
      expect(assigns(:delivery_companies)).to be_kind_of(ActiveRecord::Relation)
      expect(assigns(:delivery_companies)).to eq([delivery_company])
    end
  end

  describe "GET show" do
    it "assigns the requested delivery_company as @delivery_company" do
      delivery_company = create :delivery_company
      get :show, {id: delivery_company.to_param}, valid_session
      expect(assigns(:delivery_company)).to eq(delivery_company)
    end
  end

  describe "GET new" do
    it "assigns a new delivery_company as @delivery_company" do
      get :new, {}, valid_session
      expect(assigns(:delivery_company)).to be_a_new(DeliveryCompany)
    end
  end

  describe "GET edit" do
    it "assigns the requested delivery_company as @delivery_company" do
      delivery_company = create :delivery_company
      get :edit, {id: delivery_company.to_param}, valid_session
      expect(assigns(:delivery_company)).to eq(delivery_company)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DeliveryCompany" do
        expect do
          post :create, {delivery_company: valid_attributes}, valid_session
        end.to change(DeliveryCompany, :count).by(1)
      end

      it "assigns a newly created delivery_company as @delivery_company" do
        post :create, {delivery_company: valid_attributes}, valid_session
        expect(assigns(:delivery_company)).to be_a(DeliveryCompany)
        expect(assigns(:delivery_company)).to be_persisted
      end

      it "redirects to the created delivery_company" do
        post :create, {delivery_company: valid_attributes}, valid_session
        expect(response).to redirect_to(DeliveryCompany.last)
        # expect(response).to redirect_to(delivery_companies_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved delivery_company as @delivery_company" do
        # allow_any_instance_of(DeliveryCompany).to receive(:save).and_return(false)
        post :create, {delivery_company: invalid_attributes}, valid_session
        expect(assigns(:delivery_company)).to be_a_new(DeliveryCompany)
      end

      it "re-renders the 'new' template" do
        # allow_any_instance_of(DeliveryCompany).to receive(:save).and_return(false)
        post :create, {delivery_company: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end   # describe "POST create"

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { {name: 'New value'} }

      it "updates the requested delivery_company" do
        delivery_company = create :delivery_company
        # expect_any_instance_of(DeliveryCompany)
        #   .to receive(:update).with(new_attributes.inject({}){|_, (k, v)| _[k] = v.to_s; _})
        put :update, {id: delivery_company.to_param, delivery_company: new_attributes}, valid_session
        delivery_company.reload
        # skip("Add assertions for updated state")
        expect(delivery_company.name).to eq 'New value'
      end

      it "assigns the requested delivery_company as @delivery_company" do
        delivery_company = create :delivery_company
        put :update, {id: delivery_company.to_param, delivery_company: valid_attributes}, valid_session
        expect(assigns(:delivery_company)).to eq(delivery_company)
      end

      it "redirects to the delivery_company" do
        delivery_company = create :delivery_company
        put :update, {id: delivery_company.to_param, delivery_company: valid_attributes}, valid_session
        expect(response).to redirect_to(delivery_company)
      end
    end

    describe "with invalid params" do
      it "assigns the delivery_company as @delivery_company" do
        delivery_company = create :delivery_company
        # allow_any_instance_of(DeliveryCompany).to receive(:update).and_return(false)
        put :update, {id: delivery_company.to_param, delivery_company: invalid_attributes}, valid_session
        expect(assigns(:delivery_company)).to be_a(DeliveryCompany)
      end

      it "re-renders the 'edit' template" do
        delivery_company = create :delivery_company
        # allow_any_instance_of(DeliveryCompany).to receive(:update).and_return(false)
        put :update, {id: delivery_company.to_param, delivery_company: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end   # describe "PUT update"

  describe "DELETE destroy" do
    it "destroys the requested delivery_company" do
      delivery_company = create :delivery_company
      expect do
        delete :destroy, {id: delivery_company.to_param}, valid_session
      end.to change(DeliveryCompany, :count).by(-1)
    end

    it "redirects to the delivery_companies list" do
      delivery_company = create :delivery_company
      delete :destroy, {id: delivery_company.to_param}, valid_session
      expect(response).to redirect_to(delivery_companies_url)
    end
  end   # describe "DELETE destroy"

end
