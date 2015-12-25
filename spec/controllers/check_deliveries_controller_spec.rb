require 'rails_helper'

describe CheckDeliveriesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # CheckDelivery. As you add validations to CheckDelivery, be sure to
  # adjust the attributes here as well. The list could not be empty.
  let(:query) {'123'}
  let(:valid_attributes) do
    {
      delivery_company_id: (create :delivery_company).id,
      query: query
    }
  end
  let(:invalid_attributes) {{query: ''}}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CheckDeliveriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new check_delivery as @check_delivery" do
      get :new, {}, valid_session
      expect(assigns(:check_delivery)).to be_a(CheckDelivery)
    end
  end

  describe "POST create" do
    context "with valid params" do
#       it "creates a new CheckDelivery" do
#         expect do
#           post :create, {check_delivery: valid_attributes}, valid_session
#         end.to change(CheckDelivery, :count).by(1)
#       end
      describe 'requires information' do
        it 'sends #pull to the obtained DeliveryCompany with the query' do
          expect_any_instance_of(DeliveryCompany).to receive(:pull).with query {'OK'}
          post :create, {check_delivery: valid_attributes}, valid_session
        end

        it "assigns a newly created check_delivery as @check_delivery" do
          post :create, {check_delivery: valid_attributes}, valid_session
          expect(assigns(:check_delivery)).to be_a(CheckDelivery)
        end

        context 'when the result is a String' do
          before :each do
            allow_any_instance_of(DeliveryCompany).to receive(:pull) {'OK'}
          end

          it "renders the 'show' template" do
            post :create, {check_delivery: valid_attributes}, valid_session
            expect(response).to render_template("show")
          end
        end   # when the result is a String

        context 'when the result is not a String (Hash)' do
          before :each do
            allow_any_instance_of(DeliveryCompany).to receive(:pull) do
              {no_xpath: 'xpath'}
            end
          end

          it 'sets flash[:alert]' do
            post :create, {check_delivery: valid_attributes}, valid_session
            expect(flash[:alert]).to eq 'There is not an element at xpath xpath'
          end

          it "re-renders the 'new' template" do
            # allow_any_instance_of(CheckDelivery).to receive(:save).and_return(false)
            post :create, {check_delivery: invalid_attributes}, valid_session
            expect(response).to render_template("new")
          end
        end   # when the result is not a String (Hash)
      end   # requires information
    end   # with valid params

    context "with invalid params" do
      it "assigns a newly created but unsaved check_delivery as @check_delivery" do
        # allow_any_instance_of(CheckDelivery).to receive(:save).and_return(false)
        post :create, {check_delivery: invalid_attributes}, valid_session
        expect(assigns(:check_delivery)).to be_a(CheckDelivery)
      end

      it "re-renders the 'new' template" do
        # allow_any_instance_of(CheckDelivery).to receive(:save).and_return(false)
        post :create, {check_delivery: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end   # with invalid params
  end   # describe "POST create"

end
