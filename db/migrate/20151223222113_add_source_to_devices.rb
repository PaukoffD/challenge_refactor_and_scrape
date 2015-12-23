class AddSourceToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :created_by, :string
    add_column :devices, :source, :string
  end
end
