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
