class CreateDeliveryCompanies < ActiveRecord::Migration
  def change
    create_table :delivery_companies do |t|
      t.string :name, null: false, index: true
      t.string :url, null: false, index: true
      t.string :form_name
      t.string :form_action
      t.string :field_name, null: false
      t.string :extra_fields
      t.string :extra_values
      t.string :submit
      t.string :xpath
      t.text :css

      t.timestamps null: false
    end
  end
end
