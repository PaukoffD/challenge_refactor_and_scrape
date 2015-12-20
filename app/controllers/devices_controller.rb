require 'csv'

class DevicesController < InheritedResources::Base

  respond_to :html, :json
  belongs_to :customer, shallow: true

  def import
    @customer = Customer.find params[:customer_id]
    @warnings = []

    if @customer.devices.count(:all) == 0
      @warnings << 'This customer has no devices. The import file needs to have at least the following columns: number, username, business_account_id, device_make_id'
    end
    if @customer.business_accounts.count(:all) == 0
      @warnings << 'This customer does not have any business accounts.  Any device import will fail to process correctly.'
    end

    return unless request.post?

    @errors          = {}
    lookups          = {}
    data             = {}
    updated_devices  = {}
    removed_devices  = []
    clear_existing_data = params[:clear_existing_data]

    # Here we form the lookups Hash that for each key that can appear
    # in the input record comum name supplies the Hash of pairs vaule => :id
    #
    # If an association Class respond_to :export_key the name returned
    # will be used insted of "name"
    Device.import_export_columns.each do |col|
      if col =~ /^(\w+)_id/
        case col
        when 'device_make_id'
          lookups[col] = Hash[DeviceMake.pluck(:name, :id)]
        when 'device_model_id'
          lookups[col] = Hash[DeviceModel.pluck(:name, :id)]
        else
          Device.reflections.each do |k, reflection|
            if reflection.foreign_key == col
              logger.debug "DevicesController@#{__LINE__}#import #{reflection.inspect}" if logger.debug?
              accessor = reflection.klass.respond_to?(:export_key) ? reflection.klass.send(:export_key) : 'name'
              method = reflection.plural_name.to_sym
              if @customer.respond_to?(method)
                lookups[col] = Hash[@customer.send(method).pluck(accessor, :id)]
              else
                lookups[col] = Hash[reflection.klass.pluck(accessor, :id)]
              end
            end
          end
        end
      end
    end   # Device.import_export_columns.each

    @customer.accounting_types.each do |acc_type|
      lookups["accounting_categories[#{acc_type.name}]"] = Hash[acc_type.accounting_categories.pluck(:name, :id).map{|k,v| [k.strip, v]}]
    end

    # We need this in a string since we parse it twice and Ruby will
    # automatically close and GC it if we don't
    import_file = params[:import_file]
    if !import_file
      return flash[:error] = 'Please upload a file to be imported'
    end

    contents = import_file.tempfile.read.encode(invalid: :replace, replace: '')

    # Check that input file has only existing accounting_categories names
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
      CSV.parse(contents, headers: true, encoding: 'UTF-8').each_with_index do |row, index|
        accounting_categories = []
        row_data = row.to_hash.merge(customer_id: @customer.id)

        # Check validity of the number
        # Hardcode the number, just to make sure we don't run into issues
        number = row_data['number'] = row_data['number'].gsub(/\D+/,'')
        (@errors['General'] ||= []) << "An entry around line #{index} has no number" and next if number.blank?
        (@errors[number] ||= []) << "Is a duplicate entry" and next if data[number]

        # Process sthrin assingments
        row_data = Hash[row_data.map{|k, v| [k, v =~ /^="(.*?)"/ ? $1 : v] }]

        # Replace the values with the ids from lookups
        row_data.keys.each do |attr|
          value = row_data[attr]
          if lookups.key? attr
            if attr =~ /accounting_categories/
              accounting_type = attr.gsub(/accounting_categories\[(.*?)\]/, '\1')
              val = lookups[attr][value.to_s.strip]
              if !val
                # Why not to create a new accounting_type?
                (@errors[number] ||= []) << "New \"#{accounting_type}\" code: \"#{value.to_s.strip}\""
              else
                accounting_categories << val
              end
              row_data.delete(attr)
            else
              row_data[attr] = lookups[attr][value]
            end
          end   # if lookups.key? attr
          # Boolean values
          if value == 't' || value == 'f'
            # This is postgres-specific
            row_data[attr] = (value == 't')
          end
        end
        row_data['accounting_category_ids'] = accounting_categories if accounting_categories.present?
        # Are there any?
        data[number] = row_data.select{|attr, value| attr }
      end
    rescue => e
      @errors['General'] = [e.message]
    end

    # Duplicated_numbers
    Device.where(number: data.keys)
      .where.not(customer_id: @customer.id)
      .where.not(status: 'cancelled')
    .each do |device|
      if data[device.number]['status'] != 'cancelled'
        (@errors[device.number] ||= []) << "Duplicate number. The number can only be processed once, please ensure it's on the active account number."
      end
    end

    # Shortcut here to get basic errors out of the way
    return if @errors.length > 0

    @customer.devices.each do |device|
      if data.has_key?(device.number)
        updated_devices[device.number] = device
      elsif clear_existing_data
        removed_devices << device
      end
    end

    data.each do |number, attributes|
      updated_devices[number] = Device.new unless updated_devices[number]
    end

    number_conditions = []
    updated_devices.each do |number, device|
      device.assign_attributes(data[number])
      @errors[number] = device.errors.full_messages unless device.valid?
      number_conditions << "(number = '#{number}' AND status <> 'cancelled')" unless device.cancelled?
    end

    if number_conditions.size.nonzero?
      invalid_devices = Device.unscoped.where("(#{number_conditions.join(' OR ')}) AND customer_id != ?", @customer.id)
      invalid_devices.each do |device|
        (@errors[device.number] ||= []) << "Already in the system as an active number"
      end
    end

    # Let us save the work
    Device.transaction do
      if @errors.empty?
        updated_devices.each do |number, device|
          device.track!(created_by: current_user, source: "Bulk Import") do
            device.save(validate: false)
          end
        end

        if params[:clear_existing_data]
          removed_devices.each{ |device| device.delete }
        end

        flash[:notice] = "Import successfully completed. #{updated_devices.length} lines updated/added. #{removed_devices.length} lines removed."
      else
        raise ActiveRecord::Rollback
      end
    end   # Device.transaction
  end   # import

  private

  def device_params
    params.require(:device).permit(:number, :customer_id, :device_make_id, :device_model_id, :status, :imei_number, :sim_number, :model, :carrier_base_id, :business_account_id, :contract_expiry_date, :username, :location, :email, :employee_number, :contact_id, :inactive, :in_suspension, :is_roaming, :additional_data_old, :added_features, :current_rate_plan, :data_usage_status, :transfer_to_personal_status, :apple_warranty, :eligibility_date, :number_for_forwarding, :call_forwarding_status, :asset_tag)
  end
end

