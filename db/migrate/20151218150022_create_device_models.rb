class CreateDeviceModels < ActiveRecord::Migration
  def change
    create_table :device_models do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
