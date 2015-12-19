class CreateJoinTableAccountingCategoriesDevices < ActiveRecord::Migration
  def change
    create_join_table :accounting_categories, :devices do |t|
      # t.index [:accounting_category_id, :device_id]
      # t.index [:device_id, :accounting_category_id]
    end
  end
end
