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

    context 'without parameter :import_file' do
      it 'renders :import template with flash :error set and empty @errors' do
        post :import, {customer_id: customer.id}, valid_session
        expect(response).to render_template("import")
        expect(controller.flash.keys).to eq ['error']
        expect(assigns :errors).to be_blank
      end
    end   # without parameter :import_file

    context 'with file without records' do
      let(:file)  {fixture_file_upload '/only_header.csv'}

      it 'generates error that the file is empty' do
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(assigns(:errors)['General']).to eq 'There is no data in the file'
      end
    end

    it 'calls Device.lookups with customer' do
      expect(Device).to receive(:lookups).twice.with(customer).and_return({})
      post :import, {customer_id: customer.id, import_file: file}, valid_session
    end

    describe 'calls Device.check_headers with @customer and array of headers and' do
      let(:headers) {%w[username number device_make_id business_account_id status]}

      context 'when the result is blank' do
        let(:result) {[]}

        it 'leaves errors["General"] blank' do
          expect(Device).to receive(:check_headers).with(customer, headers).and_return result
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors)['General']).to be nil
        end
      end   # when the result is blank

      context 'when the result has elements' do
        let(:result) {['Heder']}

        it 'fills errors["General"] with messages if any name is received' do
          expect(Device).to receive(:check_headers).with(customer, headers).and_return result
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors)['General']).to be_present
          expect(assigns(:errors)['General'].size).to be 1
          expect(assigns(:errors)['General'].first).to eq "'Heder' is not a valid accounting type"
        end

        it 'stops processing' do
          allow(Device).to receive(:check_headers).and_return result
          expect(Device).not_to receive :import
          post :import, {customer_id: customer.id, import_file: file}, valid_session
        end
      end   # when the result has elements
    end   # calls Device.check_headers

    describe 'calls Device.import with csv, customer, clear_existing_data and current_user' do
      it 'passing data' do
        allow(controller).to receive(:current_user).and_return('CU')
        expect(Device).to receive(:import)
          .with(instance_of(CSV::Table), customer, 'remove', 'CU')
          .and_return [1, 1]
        post :import,
            {customer_id: customer.id, import_file: file, clear_existing_data: 'remove'},
            valid_session
      end

      it 'when an Array is returned fille the flash' do
        allow(Device).to receive(:import).and_return [2, 1]
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(controller.flash[:notice]).to eq 'Import successfully completed. 2 lines updated/added. One line removed.'
      end

      it 'when a Hash is returned fills @errors' do
        allow(Device).to receive(:import).and_return '12' => ['Text message'],
          '23' => [[:unknown_accounting_category, 5, 'type', 'code']]
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(assigns(:errors)).to eq '12' => ['Text message'],
            "23" => ['New "type" code: "code" at the line 5']
      end
    end   # calls Device.import scv, customer, clear_existing_data and current_user

    # TODO: remove me
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
        expect(assigns(:errors)).to be_blank
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

    # TODO: remove me
    context 'when the csv data file has a column for AccountingCategory with unexisting AccountingType' do
      let(:file) {fixture_file_upload '/task_data.csv'}

      it 'renders :import template with @erros set' do
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(response).to render_template("import")
        expect(assigns :errors).to be_present
        expect(assigns(:errors)['General'].size).to be 2
        expect(assigns(:errors)['General']).to include "'Reports To' is not a valid accounting type"

      end

      it 'lists all the cases' do
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(assigns(:errors)['General'].size).to satisfy{|v| v > 1}
      end
    end   # when the csv data file has a column for AccountingCategory with unexisting AccountingType

    # TODO: remove me
    context 'with a required attribute missing' do
      let(:file) {fixture_file_upload '/with_missing_attribute.csv'}

      before :each do
        business_account    # to create
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
      end

      it 'does not store the device' do
        expect do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
        end.not_to change(Device, :count)
      end

      it 'adds the error for this device number to the @errors' do
        post :import, {customer_id: customer.id, import_file: file}, valid_session
        expect(assigns(:errors).size).to be 1
        expect(assigns(:errors)['4038283663']).to eq ["Device make can't be blank"]
      end
    end   # with a required attribute missing

    # TODO: remove me
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

    # TODO: remove me
      context 'when a line in the csv file has not a device number in one line' do
        let(:file) {fixture_file_upload '/minimal_wo_number.csv'}

        it 'does not store any line' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.not_to change(Device, :count)
        end

        it 'adds the General error to the @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 1
          expect(assigns(:errors)['General']).to eq ["An entry at the line 2 has no number"]
        end
      end   # when a line in the csv file has not a device number

    # TODO: remove me
      context 'when a device number is repeated on a line' do
        let(:file) {fixture_file_upload '/minimal_with_repeated_number.csv'}

        it 'does not store any line' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.not_to change(Device, :count)
        end

        it 'adds the error for this device number to the @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 1
          expect(assigns(:errors)['4038283663']).to eq ["There is a duplicate entry at the line 3"]
        end
      end   # when a device number is repeated on a line

    # TODO: remove me
      context 'with an unknown accounting_category' do
        let(:file) {fixture_file_upload '/with_new_accounting_category.csv'}

        it 'does not store any line' do
          expect do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
          end.not_to change(Device, :count)
        end

        it 'adds the error for this device number to the @errors' do
          post :import, {customer_id: customer.id, import_file: file}, valid_session
          expect(assigns(:errors).size).to be 1
          expect(assigns(:errors)['4038283663']).to eq ['New "Cost Center" code: "10010.8351" at the line 2']
        end
      end   # with an unknown accounting_category
    end   # with a mminimal set of fields

    # TODO: remove me
    context 'when another customer has the device with the same number' do
      let(:file) {fixture_file_upload '/minimal.csv'}
      let(:status) {'active'}

      before :each do
        accounting_category # to create
        business_account    # to create
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
        create :device, number: '4038283663', status: status
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
          expect(assigns(:errors)).to be_blank
        end
      end   # and its status is "cancelled

      context 'and its status is not "cancelled"' do
        context 'and the status of the new one is not "cancelled"' do
          it 'does not store any line' do
            expect do
              post :import, {customer_id: customer.id, import_file: file}, valid_session
            end.not_to change(Device, :count)
          end

          it 'adds the error for this device number to the @errors' do
            post :import, {customer_id: customer.id, import_file: file}, valid_session
            expect(assigns(:errors).size).to be 1
            expect(assigns(:errors)['4038283663'].size).to be 1
            expect(assigns(:errors)['4038283663']).to eq ["Duplicate number. The number can only be processed once, please ensure it's on the active account number."]
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
            expect(assigns(:errors)).to be_blank
          end
        end   # and the status of the new one is "cancelled
      end   # and its status is not "cancelled
    end   # when another customer has the device with the same number

    # TODO: remove me
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

        it 'reports in flash "Import successfully completed. 2 lines updated/added. "' do
          post :import, {customer_id: customer.id, import_file: two_others}, valid_session
          expect(controller.flash['notice'])
              .to eq "Import successfully completed. 2 lines updated/added. "
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

        it 'reports in flash "Import successfully completed. 2 lines updated/added. One line removed."' do
          post :import,
              {customer_id: customer.id, import_file: two_others, clear_existing_data: true},
              valid_session
          expect(controller.flash['notice'])
              .to eq "Import successfully completed. 2 lines updated/added. One line removed."
        end
      end   # whito parameter :clear_existing_data
    end   # updating the data
  end   # describe "POST import"
end
