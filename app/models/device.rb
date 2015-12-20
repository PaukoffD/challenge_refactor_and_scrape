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

# Model Device
#
class Device < ActiveRecord::Base

  belongs_to :customer
  belongs_to :device_make
  belongs_to :device_model
  belongs_to :carrier_base
  belongs_to :business_account
  has_and_belongs_to_many :accounting_categories

  validates :number, presence: true, uniqueness: true
  validates :business_account, :customer, :device_make, :status, :username,
      presence: true

  scope :ordered, -> { order(:number) }

  def cancelled?
    status == 'cancelled'
  end

  def track!(attributtes = {})
    # FIXME: add attributtes processing
    yield
  end

  class << self
    def import_export_columns
      blacklist = %w{
        customer_id
        id
        heartbeat
        hmac_key
        hash_key
        additional_data
        model_id
        deferred
        deployed_until
        device_model_mapping_id
        transfer_token
        carrier_rate_plan_id
      }
      (column_names - blacklist).reject{ |c| c =~ /_at$/ } # Reject timestamps
    end
  end   # class << self
end
