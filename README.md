# This is a Ruby on Rails Developer Applicants Test

#### It has two parts

## Refactor method

### Description

Devices#import needs some love right now. Please refactor it.

If you don't fully understand something, then in real life it would be better to ask it.

But for now, please make an assumption and document it somewhere or just write a stub for missing functionality.

#### Example of the CSV file to import

    username,number,location,model,contract_expiry_date,email,device_make_id,contact_id,inactive,in_suspension,is_roaming,carrier_base_id,business_account_id,imei_number,sim_number,employee_number,additional_data_old,device_model_id,added_features,current_rate_plan,data_usage_status,transfer_to_personal_status,apple_warranty,eligibility_date,number_for_forwarding,call_forwarding_status,asset_tag,status,accounting_categories[Reports To],accounting_categories[Cost Center]
    Guy Number 1,5879814504,Edmonton,iPad Air 32GB,,,Tablet,,f,f,f,Telus,"=""01074132""","=""""","=""8912230000293881017""",,"{""accounting_categories_percentage"":[""100""],""partial_accounting_categories"":null}",iPad Air 32GB,"International Calling On, International Voice Roaming On, Corp Roam Intl Zone1",Cost Assure Data for Tablet,unblocked,not_transfered,{},,,not_active,,active,"=""10010 Corporate Development""","=""10010.8350"""
    Guy Number 2,4038283663,Calgary,6,2018-10-07,,iPhone,,f,f,f,Telus,"=""01074132""","=""359307063973495""","=""8912230000193245107""",231134,"{""accounting_categories_percentage"":[""100""],""partial_accounting_categories"":null}",6,"Minutes 150, Corp Roam US Rates, International Data Roaming On",Corp $12.50 PCS Voice Plan,unblocked,not_transfered,{},,,not_active,,active,"=""10083 INT - International""","=""10083.8350"""
    Vacation Disconnect,4038269268,Calgary,5C,2016-04-11,,iPhone,,f,t,f,Telus,"=""01074132""","=""013838005788920""","=""8912230000147718936""",,"{""accounting_categories_percentage"":[""100""],""partial_accounting_categories"":null}",5C,International Data Roaming,Corp $12.50 PCS Voice Plan,unblocked,not_transfered,{},,,not_active,,suspended,"=""10083 INT - International""","=""10083.8350"""
    Vacation Disconnect,7808161381,Wainwright,LG A341,2016-04-11,,Cell Phone,,f,f,f,Telus,"=""01074132""","=""352262051494995""","=""8912230000126768100""",,"{""accounting_categories_percentage"":[""100""],""partial_accounting_categories"":null}",LG A341,"Corp Roam Intl Zone2, Corp Roam US Rates,Corp - Unlimited text msg",Corp $12.50 PCS Voice Plan,unblocked,not_transfered,{},,,not_active,,active,"=""26837 Carson Wainwright""","=""26837.7037.18"""

#### Ruby

    class Customer
      has_many :devices
      has_many :business_accounts
      has_many :accounting_types
    end

    class AccountingType
      has_many :accounting_categories
    end

    class Device
      belongs_to :customer
      has_and_belongs_to_many :accounting_categories

      def self.import_export_columns
        blacklist = %w{
          customer_id
          id
          heartbeat
          hmac_key
          hash_key
          additional_data
          model_id
          deferred
          deployed_until
          device_model_mapping_id
          transfer_token
          carrier_rate_plan_id
        }
        (Device.column_names - blacklist).reject{ |c| c =~ /_at$/ } # Reject timestamps
      end
    end

    class DevicesController < InheritedResources::Base
      def import
        @errors = {}

        @warnings = []

        if @customer.devices.count(:all) == 0
          @warnings << 'This customer has no devices. The import file needs to have at least the following columns: number, username, business_account_id, device_make_id'
        end

        if @customer.business_accounts.count(:all) == 0
          @warnings << 'This customer does not have any business accounts.  Any device import will fail to process correctly.'
        end

        if request.post?
          data          = {}
          updated_lines = {}
          lookups       = {}
          delete_lines  = []
          clear_existing_data = params[:clear_existing_data]

          Device.import_export_columns.each do |col|
            if col =~ /^(\w+)_id/
              case col
              when 'device_make_id'  then lookups[col] = Hash[DeviceMake.pluck(:name, :id)]
              when 'device_model_id' then lookups[col] = Hash[DeviceModel.pluck(:name, :id)]
              else
                Device.reflections.each do |k, reflection|
                  if reflection.foreign_key == col
                    puts reflection.inspect
                    method = reflection.plural_name.to_sym
                    if @customer.respond_to?(method)
                      accessor = reflection.klass.respond_to?(:export_key) ? reflection.klass.send(:export_key) : 'name'
                      lookups[col] = Hash[@customer.send(method).pluck(accessor, :id)]
                    end
                  end
                end
              end
            end
          end

          @customer.accounting_types.each do |at|
            lookups["accounting_categories[#{at.name}]"] = Hash[Hash[at.accounting_categories.pluck(:name, :id)].map{ |k,v| [k.strip, v] }]
          end

          # We need this in a string since we parse it twice and Ruby will
          # automatically close and GC it if we don't
          import_file = params[:import_file]
          if !import_file
            return flash[:error] = 'Please upload a file to be imported'
          end

          contents = import_file.tempfile.read.encode(invalid: :replace, replace: '')

          begin
            CSV.parse(contents, headers: true, encoding: 'UTF-8').each do |row|
              row.headers.each do |header|
                if header =~ /accounting_categories\[([^\]]+)\]/
                  unless lookups.key?(header)
                    raise "'#{$1}' is not a valid accounting type"
                  end
                end
              end
              break
            end
          rescue => e
            @errors['General'] = [e.message]
          end

          if @errors.length.nonzero?
            return
          end

          begin
            CSV.parse(contents, headers: true, encoding: 'UTF-8').each_with_index do |p, idx|
              accounting_categories = []
              hsh = p.to_hash.merge(customer_id: @customer.id)

              if '' == p['number'].to_s.strip
                (@errors['General'] ||= []) << "An entry around line #{idx} has no number"
                next
              end

              # Hardcode the number, just to make sure we don't run into issues
              hsh['number'] = p['number'] = hsh['number'].gsub(/\D+/,'')

              if data[p['number']]
                (@errors[p['number']] ||= []) << "Is a duplicate entry"
                next
              end

              hsh = Hash[hsh.map{ |k,v| [k, v =~ /^="(.*?)"/ ? $1 : v] }]

              hsh.dup.each do |k,v|
                if lookups.key?(k)
                  if k =~ /accounting_categories/
                    accounting_category_name = k.gsub(/accounting_categories\[(.*?)\]/, '\1')
                    val = lookups[k][v.to_s.strip]
                    if !val
                      (@errors[p['number']] ||= []) << "New \"#{accounting_category_name}\" code: \"#{v.to_s.strip}\""
                    else
                      accounting_categories << lookups[k][v.to_s.strip]
                    end
                    hsh.delete(k)
                  else
                    hsh[k] = lookups[k][v]
                  end
                end
                if v == 't' || v == 'f'
                  # This is postgres-specific
                  hsh[k] = (v == 't')
                end
              end
              hsh['accounting_category_ids'] = accounting_categories unless accounting_categories.empty?
              data[p['number']] = hsh.select{ |k,v| k }
            end
          rescue => e
            @errors['General'] = [e.message]
          end

          duplicate_numbers = Device.where(number: data.keys).where.not(customer_id: @customer.id)
          duplicate_numbers.each do |device|
            if !device.cancelled? && data[device.number]['status'] != 'cancelled'
              (@errors[device.number] ||= []) << "Duplicate number. The number can only be processed once, please ensure it's on the active account number."
            end
          end

          # Shortcut here to get basic errors out of the way
          return if @errors.length > 0

          lines = @customer.devices.to_a
          lines.each do |line|
            if data.has_key?(line.number)
              updated_lines[line.number] = line
            elsif clear_existing_data
              delete_lines << line
            end
          end

          Device.transaction do
            updated_lines.each do |number, line|
              line.assign_attributes(data[number])
            end

            data.each do |number, attributes|
              unless updated_lines[number]
                updated_lines[number] = Device.new
                updated_lines[number].assign_attributes(attributes)
              end
            end

            updated_lines.each do |number, line|
              unless line.valid?
                @errors[number] = line.errors.full_messages
              end
            end

            number_conditions = []
            updated_lines.each do |number, device|
              number_conditions << "(number = '#{number}' AND status <> 'cancelled')" unless device.cancelled?
            end

            if number_conditions.size.nonzero?
              invalid_devices = Device.unscoped.where("(#{number_conditions.join(' OR ')}) AND customer_id != ?", @customer.id)
              invalid_devices.each do |device|
                (@errors[device.number] ||= []) << "Already in the system as an active number"
              end
            end

            if @errors.empty?
              updated_lines.each do |number, line|
                line.track!(created_by: current_user, source: "Bulk Import") { line.save(validate: false) }
              end

              if params[:clear_existing_data]
                delete_lines.each{ |line| line.delete }
              end

              flash[:notice] = "Import successfully completed. #{updated_lines.length} lines updated/added. #{delete_lines.length} lines removed."
            else
              raise ActiveRecord::Rollback
            end
          end
        end
      end
    end

### Notes

1. Of course, for simplicity the authorization and authentications are omitted. The controller variable `current_user` will return a string as a stub ;-)
1. For sure db/seeds.rb is needed only for the purpose of this task. I could delete them but I did not.
1. Most of the specs written for the `DevicesController` should be removed after refactoring. They are marked with  TODO comment but left in the code.
1. Some specs for `DevicesController` should be placed outside of the context 'with a mminimal set of fields' but since it is not so important I've left them there for simplicity since they are to be removed at the end.
1. As the sample csv file for devices contains different values in the field `username` and exiting code processes all the lines of the csv file, I assume it is the field of the `Device` that refers to some person affiliated to `Customer`.
1. It is strange that `AccountingType`s are individual for each `Customer`. Should not it be considered to try to use the common dictionary?
1. It would be not bad to strip `AccountingCategory#name` at the `save` time in order not to do it each time later at import Devices. ;-)

### Bugs found

**Please, note that I did not try to fix any bug as it is not required.**

I'm not sure, but the following things seems to be buggy. Maybe some of them is _a feature_ ;-)

1. One of the following **three** things should take place
  1. `Customer` should have `have_and_belongs_to_many :carrier_bases`
  2. The csv file should not contain field `carrier_base_id`.
  3. The code must process `carrier_base_id` field properly. Now it nullifies it.

  So I decided that the most obvious case takes place, `:carrier_base` is the assosiation of `Device`. Since the nullification of the `carrier_base_id` causes exception I've **FIXED** this bug.
1. The columns in csv file that are unknown for `Device` are not filtered out and cause an error.
1. There is no diagnostics when `accounting_categories` for any `AccountingType` has unknown value.
