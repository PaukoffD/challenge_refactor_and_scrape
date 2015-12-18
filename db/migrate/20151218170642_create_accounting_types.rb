class CreateAccountingTypes < ActiveRecord::Migration
  def change
    create_table :accounting_types do |t|
      t.belongs_to :customer, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
