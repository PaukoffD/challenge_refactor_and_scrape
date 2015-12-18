# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
['Tablet', 'iPhone', 'Cell Phone'].each do |name|
  DeviceMake.find_or_create_by name: name
end

['iPad Air 32GB', '6', '5C', 'LG A341'].each do |name|
  DeviceModel.find_or_create_by name: name
end

%w[Telus].each do |name|
  CarrierBase.find_or_create_by name: name
end

CUSTOMERS = {
  'First Customer' => {
    accountings: {
      'Reports To' => [
                      "10010 Corporate Development",
                      "10083 INT - International",
                      "26837 Carson Wainwright"
                      ],
      'Cost Center' => [
                        "10010.8350",
                        "26837.7037.18"
                      ],
    },
    business_accounts: %w[01074132]
  }
}

CUSTOMERS.each do |name, data|
  customer = Customer.find_or_create_by name: name
  data[:accountings].each do |name, accounting_categories|
    type = customer.accounting_types.find_or_create_by name: name
    accounting_categories.each do |name|
      type.accounting_categories.find_or_create_by name: name
    end
  end
  data[:business_accounts].each do |name|
    customer.business_accounts.find_or_create_by name: name
  end
end
