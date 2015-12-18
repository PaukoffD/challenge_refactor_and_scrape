# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
['Tablet', 'iPhone', 'Cell Phone'].each do |name|
  DeviceMake.find_or_create_by name: name
end

['iPad Air 32GB', '6', '5C', 'LG A341'].each do |name|
  DeviceModel.find_or_create_by name: name
end

%w[01074132].each do |name|
  BusinessAccount.find_or_create_by name: name
end

%w[Telus].each do |name|
  CarrierBase.find_or_create_by name: name
end

CUSTOMERS = {
  'First Customer' => {
    'Reports To' => [
                     "10010 Corporate Development",
                     "10083 INT - International",
                     "26837 Carson Wainwright"
                    ],
    'Cost Center' => [
                      "10010.8350",
                      "26837.7037.18"
                     ],
  }
}

CUSTOMERS.each do |name, accounting_types|
  customer = Customer.find_or_create_by name: name
  accounting_types.each do |name, accounting_categories|
    type = customer.accounting_types.find_or_create_by name: name
    accounting_categories.each do |name|
      type.accounting_categories.find_or_create_by name: name
    end
  end
end
