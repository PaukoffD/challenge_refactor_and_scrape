class AddCustomerToBusinessAccounts < ActiveRecord::Migration
  def change
    add_reference :business_accounts, :customer, index: true, foreign_key: true
  end
end
