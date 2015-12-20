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

describe Device, type: :model do

  subject { create :device }

  it { should be_valid }

  it {should validate_presence_of :number}
  it {should validate_uniqueness_of :number}
  it {should validate_presence_of :customer}
  it {should validate_presence_of :status}

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
  end   # class

end
