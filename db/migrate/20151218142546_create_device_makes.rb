class CreateDeviceMakes < ActiveRecord::Migration
  def change
    create_table :device_makes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
