# == Schema Information
#
# Table name: devices
#
#  id                          :integer          not null, primary key
#  number                      :string
#  customer_id                 :integer
#  device_make_id              :integer
#  device_model_id             :integer
#  status                      :string
#  imei_number                 :string
#  sim_number                  :string
#  model                       :string
#  carrier_base_id             :integer
#  business_account_id         :integer
#  contract_expiry_date        :date
#  username                    :string
#  location                    :string
#  email                       :string
#  employee_number             :string
#  contact_id                  :string
#  inactive                    :boolean
#  in_suspension               :boolean
#  is_roaming                  :boolean
#  additional_data_old         :string
#  added_features              :string
#  current_rate_plan           :string
#  data_usage_status           :string
#  transfer_to_personal_status :string
#  apple_warranty              :string
#  eligibility_date            :string
#  number_for_forwarding       :string
#  call_forwarding_status      :string
#  asset_tag                   :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

require 'rails_helper'
require 'csv'

describe Device, type: :model do

  subject { create :device }

  it { should be_valid }

  it {should validate_presence_of :business_account}
  it {should validate_presence_of :customer}
  it {should validate_presence_of :device_make}
  it {should validate_presence_of :number}
  it {should validate_presence_of :status}
  it {should validate_presence_of :username}

  it {should belong_to :business_account}
  it {should belong_to :carrier_base}
  it {should belong_to :customer}
  it {should belong_to :device_make}
  it {should belong_to :device_model}
  it {should have_and_belong_to_many :accounting_categories}

  describe '#cancelled?' do
    context 'when status is not "cancelled"' do
      it 'returns false' do
        expect(subject.cancelled?).to be false
      end
    end   # when status is "cancelled"

    context 'when status is "cancelled"' do
      subject {create :device, status: 'cancelled'}
      it 'returns true' do
        expect(subject.cancelled?).to be true
      end
    end   # when status is "cancelled"
  end   #cancelled?

  describe '#track!' do
    it 'shoud call the block'do
      expect { |b| subject.track!(&b) }.to yield_with_no_args
    end

    it 'assigns attributes given' do
      skip 'FIXME: It is needed to add necessary attributes'
    end
  end   #track!

  describe :class do
    let(:customer) {create :customer}
    let(:accounting_type) {create :accounting_type, customer: customer, name: 'Cost Center'}
    let(:accounting_category) do
      create :accounting_category, accounting_type: accounting_type, name: '10010.8350'
    end
    let(:business_account) {create :business_account, customer: customer, name: '01074132'}
    let(:device_make) {create :device_make}
    let(:device_model) {create :device_model}
    let(:carrier_base) {create :carrier_base}

    describe :scope do
      describe '.ordered' do
        it 'sort Device by :ordered' do
          create :device
          create :device
          expect(Device.ordered).to eq Device.order(:number)
        end
      end   # .ordered
    end   # scope

    describe '.import_export_columns' do
      it 'returns the list of columns without timestamps' do
        expect(Device.import_export_columns.sort).to eq %w[
          added_features
          additional_data_old
          apple_warranty
          asset_tag
          business_account_id
          call_forwarding_status
          carrier_base_id
          contact_id
          contract_expiry_date
          current_rate_plan
          data_usage_status
          device_make_id
          device_model_id
          eligibility_date
          email
          employee_number
          imei_number
          in_suspension
          inactive
          is_roaming
          location
          model
          number
          number_for_forwarding
          sim_number
          status
          transfer_to_personal_status
          username
        ]
      end
    end   # .import_export_columns

    describe '.lookups' do
      lookup_keys = [
        'accounting_categories[Cost Center]',
        'business_account_id',
        'carrier_base_id',
        'device_make_id',
        'device_model_id',
      ]

      before :each do
        # to create
        accounting_category
        business_account
        device_make
        device_model
        carrier_base
      end   # before :each

      it "returns a Hash with the keys #{lookup_keys}" do
        expect(Device.lookups customer).to be_a_kind_of(Hash)
        expect(Device.lookups(customer).keys.sort).to eq lookup_keys
      end

      it '["accounting_categories[Cost Center]"] is a Hash' do
        expect(Device.lookups(customer)['accounting_categories[Cost Center]'])
            .to eq accounting_category.name => accounting_category.id
      end

      it '[:business_account_id] is a Hash' do
        expect(Device.lookups(customer)[:business_account_id])
            .to eq business_account.name => business_account.id
      end

      it '[:carrier_base_id] is a Hash' do
        expect(Device.lookups(customer)[:carrier_base_id])
            .to eq carrier_base.name => carrier_base.id
      end

      it '[:device_make_id] is a Hash' do
        expect(Device.lookups(customer)[:device_make_id])
            .to eq device_make.name => device_make.id
      end

      it '[:device_model_id] is a Hash' do
        expect(Device.lookups(customer)[:device_model_id])
            .to eq device_model.name => device_model.id
      end
    end     # .lookups

    describe '.check_headers' do
      before :each do
        # to create
        accounting_category
      end   # before :each

      context 'when headrs do not contain unknown AccountingType for accounting_category' do
        let(:headers) {[]}

        it 'returns nil' do
          expect(Device.check_headers customer, headers).to eq []
        end
      end   # when headrs do not contain unknown AccountingType for accounting_category

      context 'when headrs contain unknown AccountingType for accounting_category' do
        let(:headers) {%w(accounting_categories[UK1] accounting_categories[UK2])}

        it 'returns the list of unknown AccountingTypes met' do
          expect(Device.check_headers customer, headers).to eq %w[UK1 UK2]
        end
      end   # when headrs contain unknown AccountingType for accounting_category
    end   # .check_headers

    describe '.parse' do
      let(:csv) {CSV.open fixture_path + '/minimal.csv', headers: true}
      before :each do
        # to create
        accounting_category
        business_account
        device_make
        device_model
        carrier_base
        ['Tablet', 'iPhone', 'Cell Phone'].each do |name|
          DeviceMake.find_or_create_by name: name
        end
      end   # before :each

      it 'reads the csv file and returns a Hash of attributes for the Device and a Hash for errors' do
        result, errors = Device.parse csv, customer
        expect(result).to be_a_kind_of Hash
        expect(errors).to be_a_kind_of Hash
        expect(result.keys.sort).to eq %w[
          4038269268
          4038283663
          7808161381
        ]
        expect(errors).to be_empty
      end

      context 'with missing header in scv' do
        let(:csv) {CSV.open fixture_path + '/missing_header.csv', headers: true}

        it 'moves data to the result and adds nothing to errors' do
          result, errors = Device.parse csv, customer
          expect(result.size).to be 1
          expect(errors.size).to be 0
        end
      end

      context 'when a line in the csv file has not a device number in one line' do
        let(:csv) {CSV.open fixture_path + '/minimal_wo_number.csv', headers: true}

        it 'adds the General error to the errors' do
          result, errors = Device.parse csv, customer
          expect(errors.size).to be 1
          expect(errors['General'].size).to be 1
          expect(errors['General']).to eq [[:no_number, 2]]
        end
      end   # when a line in the csv file has not a device number in one line

      context 'when a device number is repeated in the csv' do
        let(:csv) {CSV.open fixture_path + '/minimal_with_repeated_number.csv', headers: true}

        it 'adds the error for this device number to the errors' do
          result, errors = Device.parse csv, customer
          expect(errors.size).to be 1
          expect(errors['4038283663'].size).to be 1
          expect(errors['4038283663']).to eq [[:duplicate, 3]]
        end
      end   # when a device number is repeated in the csv

      context 'with an unknown accounting_category' do
        let(:csv) {CSV.open fixture_path + '/with_new_accounting_category.csv', headers: true}

        it 'adds the error for this device number to the @errors' do
          result, errors = Device.parse csv, customer
          expect(errors.size).to be 1
          expect(errors['4038283663'].size).to be 1
          expect(errors['4038283663'])
              .to eq [[:unknown_accounting_category, 2, "Cost Center", "10010.8351"]]
        end
      end   # with an unknown accounting_category

      context 'when another customer has a device with the same number' do
        let(:status) {'active'}

        before :each do
          create :device, number: '4038283663', status: status
        end

        context 'and its status is "cancelled"' do
          let(:status) {'cancelled'}

          it 'adds nothing to errors' do
            result, errors = Device.parse csv, customer
            expect(errors.size).to be 0
          end
        end   # and its status is "cancelled

        context 'and its status is not "cancelled"' do
          context 'and the status of the new one is not "cancelled"' do
            it 'adds the error for this device number to the errors' do
              result, errors = Device.parse csv, customer
              expect(errors.size).to be 1
              expect(errors['4038283663'].size).to be 1
              expect(errors['4038283663']).to eq [[:existing_device]]
            end
          end   # and the status of the new one is not "cancelled

          context 'and the status of the new one is "cancelled"' do
            let(:csv) {CSV.open fixture_path + '/minimal_with_cancelled.csv', headers: true}

            it 'adds nothing to errors' do
              result, errors = Device.parse csv, customer
              expect(errors.size).to be 0
            end
          end   # and the status of the new one is "cancelled
        end   # and its status is not "cancelled
      end   # when another customer has the device with the same number
    end   # .parse

    describe '.import' do
      let(:current_user) {'current_user'}   # FIXME: here should be a real object of User returned
      let(:csv) {CSV.open fixture_path + '/minimal.csv', headers: true}
      let(:clear) {}
      let(:parsed) {[data, errors]}
      let(:data) {{'0' => {}}}

      describe 'calls .parse and if errors are present' do
        let(:errors) {{'General' => 'message'}}

        it 'returns them and does not process further' do
          expect(Device).to receive(:parse).with(csv, customer).and_return(parsed)
          expect(Device).not_to receive(:transaction)
          expect(Device.import csv, customer, clear, current_user).to eq 'General' => 'message'
        end
      end   # calls .parse

      context 'when .parse returns no errors and valid atributes for NEW devices' do
        let(:errors) {{}}
        let(:data) do   # NOTE: Here must be present all required attributes
          {
            '101' => {
                      customer_id: customer.to_param,
                      username: 'Guy 1',
                      number: '101',
                      device_make_id: DeviceMake.first.to_param,
                      business_account_id: BusinessAccount.first.to_param,
                      status: 'active'
                      },
            '102' => {
                      customer_id: customer.to_param,
                      username: 'Guy 2',
                      number: '101',
                      device_make_id: DeviceMake.first.to_param,
                      business_account_id: BusinessAccount.first.to_param,
                      status: 'active'
                      },
          }
        end

        before :each do
          create :device, customer: customer, business_account: business_account
          allow(Device).to receive(:parse).and_return(parsed)
        end

        context 'without clear_existing_data' do
          it 'adds new Devices' do
            expect do
              Device.import csv, customer, clear, current_user
            end.to change(Device, :count).by 2
          end

          it 'reports about it in the array returned' do
            expect(Device.import csv, customer, clear, current_user).to eq [2, 0]
          end
        end   # without clear_existing_data

        context 'with clear_existing_data' do
          let(:clear) {true}

          it 'adds new Devices and removes old not present in the Hash' do
            expect do
              Device.import csv, customer, clear, current_user
            end.to change(Device, :count).by 1
          end

          it 'reports about it in the array returned' do
            expect(Device.import csv, customer, clear, current_user).to eq [2, 1]
          end
        end   # without clear_existing_data

      end   #when .parse returns no errors and valid atributes for NEW devices

      context 'when .parse returns no errors but any invalid atributes set for any device exists' do
        let(:errors) {{}}
        let(:data) do   # NOTE: Here must be present all required attributes
          {
            '101' => {
                      customer_id: customer.to_param,
                      username: 'Guy 1',
                      number: '101',
                      business_account_id: BusinessAccount.first.to_param,
                      status: 'active'
                      },
            '102' => {
                      customer_id: customer.to_param,
                      username: 'Guy 2',
                      number: '101',
                      device_make_id: DeviceMake.first.to_param,
                      business_account_id: BusinessAccount.first.to_param,
                      status: 'active'
                      },
          }
        end

        before :each do
          create :device, customer: customer, business_account: business_account
          allow(Device).to receive(:parse).and_return(parsed)
        end

        it 'does not add new Devices nor removes old' do
          expect do
            Device.import csv, customer, clear, current_user
          end.not_to change(Device, :count)
        end

        it 'returns errors Hash' do
          expect(Device.import csv, customer, clear, current_user)
              .to eq "101" => ["Device make can't be blank"]
        end
      end   # when .parse returns no errors but any invalid atributes set for any device exists
    end   # .import
  end   # class
end
