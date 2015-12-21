require 'rails_helper'

describe DevicesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Device. As you add validations to Device, be sure to
  # adjust the attributes here as well. The list could not be empty.
  let(:valid_attributes) {FactoryGirl.build(:device).attributes.slice *%w[
                          business_account_id
                          customer_id
                          device_make_id
                          number
                          status
                          username
                         ]}

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

  describe "GET import" do
    before :each do
      @customer = create :customer
    end

    it 'renders :import template' do
      get :import, {customer_id: @customer.id}, valid_session
      expect(response).to render_template("import")
    end

    it 'fills @warnings with two messages if @customer does not have any devices nor business_accounts' do
      get :import, {customer_id: @customer.id}, valid_session
      expect(assigns(:warnings).size).to be 2
    end

    it 'fills @warnings with one message if @customer does not have any devices' do
      create :business_account, customer: @customer
      get :import, {customer_id: @customer.id}, valid_session
      expect(assigns(:warnings).size).to be 1
    end

    it 'fills @warnings with one message if @customer does not have any ' do
      create :device, customer: @customer
      get :import, {customer_id: @customer.id}, valid_session
      expect(assigns(:warnings).size).to be 1
    end

    it 'leaves @warnings if @customer has at least one device awa business_account' do
      create :business_account, customer: @customer
      create :device, customer: @customer
      get :import, {customer_id: @customer.id}, valid_session
      expect(assigns(:warnings).size).to be 0
    end
  end   # GET import

  describe "POST import" do
    let(:customer) {create :customer}
    let(:accounting_type) {create :accounting_type, customer: customer, name: 'Cost Center'}
    let(:accounting_category) do
      create :accounting_category, accounting_type: accounting_type, name: '10010.8350'
    end
    let(:business_account) {create :business_account, customer: customer, name: '01074132'}
    let(:file)  {fixture_file_upload '/one_deivce.csv'}

    it 'calls Device.lookups with customer' do
      expect(Device).to receive(:lookups).with(customer)
      post :import, {customer_id: customer.id, import_file: file}, valid_session
    end

    context 'with the csv data file porvided' do
      data = {
        accountings: {
          'Reports To' => [
            "10010 Corporate Development",
            "10083 INT - International",
            "26837 Carson Wainwright"
          ],
          'Cost Center' => [
            "10010.8350",
            "10083.8350",
            "26837.7037.18"
          ],
        },
        business_accounts: %w[01074132]
      }

      let(:file) {fixture_file_upload '/task_data.csv'}

      before :each do
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
        ['iPad Air 32GB', '6', '5C', 'LG A341'].each do |name|
          DeviceModel.find_or_create_by name: name
        end
        %w[Telus].each do |name|
          CarrierBase.find_or_create_by name: name
        end
        @customer = create :customer, name: 'First Customer'
        data[:accountings].each do |name, accounting_categories|
          type = @customer.accounting_types.find_or_create_by name: name
          accounting_categories.each do |name|
            type.accounting_categories.find_or_create_by name: name
          end
        end
        data[:business_accounts].each do |name|
          @customer.business_accounts.find_or_create_by name: name
        end
      end   # before :each

      it 'adds four entries to Deivce' do
        expect do
          post :import, {customer_id: @customer.id, import_file: file}, valid_session
        end.to change(Device, :count).by(4)
      end

      it 'does not add any Device if @customer.has no business_account' do
        @customer.reload.business_accounts.delete_all
        expect(@customer.business_accounts).to be_blank
        expect do
          post :import, {customer_id: @customer.id, import_file: file}, valid_session
        end.not_to change(Device, :count)
      end

      it 'leaves @errors to be blank' do
        post :import, {customer_id: @customer.id, import_file: file}, valid_session
        expect(assigns(:errors).size).to be 0
      end

      it 'correctly fills all the associated fields' do
        attributes = Device.attribute_names.select do |attr|
          attr =~ /_id$/
        end.map do |attr|
          attr = attr.sub(/_id$/, '')
        end.reject do |attr|
          attr == 'contact'  # contact_id is not of association
        end
        post :import, {customer_id: @customer.id, import_file: file}, valid_session
        device = Device.last
        expect(attributes.map{|attr| device.send(attr)}.all?).to be true
      end
    end   # with the csv data file porvided

    context 'without parameter :import_file' do
      it 'renders :import template with flash :error set and empty @errors' do
        post :import, {customer_id: customer.id}, valid_session
        expect(response).to render_template("import")
        expect(controller.flash.keys).to eq ['error']
        expect(assigns :errors).to be_blank
      end
    end   # without parameter :import_file

    context 'when the csv data file has a column for AccountingCategory with unexisting AccountingType' do
      let(:file) {fixture_file_upload '/task_data.csv'}

      it 'renders :import template with @erros set' do
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(response).to render_template("import")
        expect(assigns :errors).to be_present
        expect(assigns(:errors)['General']).to be_present
      end

      it 'lists all the cases' do
        skip 'FIXME!'
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(assigns(:errors)['General'].size).to satisfy{|v| v > 1}
      end
    end

    context 'with a mminimal set of fields' do
      let(:file) {fixture_file_upload '/minimal.csv'}

      before :each do
        accounting_category # to create
        business_account    # to create
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
      end

      it 'adds the records to Device' do
        expect do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
        end.to change(Device, :count).by(3)
      end

      context 'when a line in the csv file has not a device number in one line' do
        let(:file) {fixture_file_upload '/minimal_wo_number.csv'}

        it 'does not store any line FIXME: to be removed' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.not_to change(Device, :count)
        end

        it 'stores the rest lines' do
          skip 'FIXME if needed or remove otherwise'
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.to change(Device, :count).by(2)
        end

        it 'adds the General error to the @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 1
          expect(assigns(:errors)['General'].size).to be 1
        end
      end   # when a line in the csv file has not a device number

      context 'when a device number is repeated on a line' do
        let(:file) {fixture_file_upload '/minimal_with_repeated_number.csv'}

        it 'does not store any line FIXME: to be removed' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.not_to change(Device, :count)
        end

        it 'stores the all the lines except the second repeated one' do
          skip 'FIXME if needed or remove otherwise'
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.to change(Device, :count).by(3)
          expect(Device.find_by(number: '4038283663').username).to eq 'Guy Number 2'
        end

        it 'adds the error for this device number to the @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 1
          expect(assigns(:errors)['4038283663'].size).to be 1
        end
      end   # when a device number is repeated on a line

      context 'with an unknown accounting_category' do
        let(:file) {fixture_file_upload '/with_new_accounting_category.csv'}

        it 'does not store any line FIXME: to be removed' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.not_to change(Device, :count)
        end

        it 'stores the all the lines except the line with unknown accounting_category' do
          skip 'FIXME if needed or remove otherwise'
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.to change(Device, :count).by(2)
        end

        it 'adds the error for this device number to the @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 1
          expect(assigns(:errors)['4038283663'].size).to be 1
        end
      end   # with an unknown accounting_category
    end   # with a mminimal set of fields

    context 'when another customer has the device with the same number' do
      let(:file) {fixture_file_upload '/minimal.csv'}
      let(:another_customer) {create :customer}
      let(:another_type) {create :accounting_type, customer: another_customer}
      let(:another_category) {create :accounting_category, accounting_type: another_type}
      let(:another_account) {create :business_account, customer: another_customer}
      let(:status) {'active'}

      before :each do
        accounting_category # to create
        business_account    # to create
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
        create :device, customer: another_customer, number: '4038283663',
            business_account: another_account, status: status
      end

      it 'at the beginning has one Device' do
        expect(Device.count).to eq 1
      end

      context 'and its status is "cancelled"' do
        let(:status) {'cancelled'}

        it 'stores the all lines' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.to change(Device, :count).by(3)
        end

        it 'adds no @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 0
        end
      end   # and its status is "cancelled

      context 'and its status is not "cancelled"' do
        context 'and the status of the new one is not "cancelled"' do
          it 'does not store any line FIXME: to be removed' do
            expect do
              post :import, {customer_id: customer.id, import_file: file}, valid_session
            end.not_to change(Device, :count)
          end

          it 'stores the all the lines except except the line with the same device number' do
            skip 'FIXME if needed or remove otherwise'
            expect do
              post :import, {customer_id: customer.id, import_file: file}, valid_session
            end.to change(Device, :count).by(2)
          end

          it 'adds the error for this device number to the @errors' do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
            expect(assigns(:errors).size).to be 1
            expect(assigns(:errors)['4038283663'].size).to be 1
          end
        end   # and the status of the new one is not "cancelled

        context 'and the status of the new one is "cancelled"' do
          let(:file) {fixture_file_upload '/minimal_with_cancelled.csv'}

          it 'stores the all lines' do
            expect do
              post :import, {customer_id: customer.id, import_file: file}, valid_session
            end.to change(Device, :count).by(3)
          end

          it 'adds no @errors' do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
            expect(assigns(:errors).size).to be 0
          end
        end   # and the status of the new one is "cancelled
      end   # and its status is not "cancelled
    end   # when another customer has the device with the same number

    context 'updating the data with two new devices' do
      let(:one_deivce) {fixture_file_upload '/one_deivce.csv'}
      let(:two_others) {fixture_file_upload '/two_others.csv'}

      before :each do
        accounting_category # to create
        business_account    # to create
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
        post :import, {customer_id: customer.id, import_file: one_deivce}, valid_session
      end

      context 'whitout parameter :clear_existing_data' do
        it 'only adds two new records' do
          expect do
            post :import, {customer_id: customer.id, import_file: two_others}, valid_session
          end.to change(Device, :count).by(2)
        end

        it 'reports in flash "Import successfully completed. 2 lines updated/added. 0 lines removed."' do
          post :import, {customer_id: customer.id, import_file: two_others}, valid_session
          expect(controller.flash['notice'])
              .to eq "Import successfully completed. 2 lines updated/added. 0 lines removed."
        end
      end   # whitout parameter :clear_existing_data

      context 'whito parameter :clear_existing_data' do
        it 'removes the old record and adds two new ones' do
          expect do
            post :import,
                {customer_id: customer.id, import_file: two_others, clear_existing_data: true},
                valid_session
          end.to change(Device, :count).by(1)
        end

        it 'reports in flash "Import successfully completed. 2 lines updated/added. 1 lines removed."' do
          post :import,
              {customer_id: customer.id, import_file: two_others, clear_existing_data: true},
              valid_session
          expect(controller.flash['notice'])
              .to eq "Import successfully completed. 2 lines updated/added. 1 lines removed."
        end
      end   # whito parameter :clear_existing_data
    end   # updating the data
  end   # describe "POST import"
end
