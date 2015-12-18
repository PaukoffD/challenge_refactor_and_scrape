class CreateCarrierBases < ActiveRecord::Migration
  def change
    create_table :carrier_bases do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
