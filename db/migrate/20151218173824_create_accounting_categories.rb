class CreateAccountingCategories < ActiveRecord::Migration
  def change
    create_table :accounting_categories do |t|
      t.belongs_to :accounting_type, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
