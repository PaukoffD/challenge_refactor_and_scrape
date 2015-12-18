class CreateBusinessAccounts < ActiveRecord::Migration
  def change
    create_table :business_accounts do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
