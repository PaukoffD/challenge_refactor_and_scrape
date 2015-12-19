class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :number
      t.belongs_to :customer, index: true, foreign_key: true
      t.belongs_to :device_make, index: true, foreign_key: true
      t.belongs_to :device_model, index: true, foreign_key: true
      t.string :status
      t.string :imei_number
      t.string :sim_number
      t.string :model
      t.belongs_to :carrier_base, index: true, foreign_key: true
      t.belongs_to :business_account, index: true, foreign_key: true
      t.date :contract_expiry_date
      t.string :username
      t.string :location
      t.string :email
      t.string :employee_number
      t.string :contact_id
      t.boolean :inactive
      t.boolean :in_suspension
      t.boolean :is_roaming
      t.string :additional_data_old
      t.string :added_features
      t.string :current_rate_plan
      t.string :data_usage_status
      t.string :transfer_to_personal_status
      t.string :apple_warranty
      t.string :eligibility_date
      t.string :number_for_forwarding
      t.string :call_forwarding_status
      t.string :asset_tag

      t.timestamps null: false
    end
  end
end
