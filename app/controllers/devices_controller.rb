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

    @errors = {}
    import_file = params[:import_file]
    return flash[:error] = 'Please upload a file to be imported' if import_file.blank?
    clear_existing_data = params[:clear_existing_data]

    # We need this in a string since we parse it twice and Ruby will
    # automatically close and GC it if we don't
    contents = import_file.tempfile.read.encode(invalid: :replace, replace: '')
    csv = CSV.parse(contents, headers: true, encoding: 'UTF-8')
    return @errors['General'] = t('.not_csv') unless csv.is_a? CSV::Table
    return @errors['General'] = t('.not_row') unless csv.first.is_a? CSV::Row

    # Check that headers have only existing accounting_types
    unknown = Device.check_headers @customer, csv.headers
    return @errors['General'] = unknown.map do |header|
      t '.unknown_accounting_type', name: header
    end if unknown.present?

    lookups = Device.lookups @customer
    # Prepare the data Hash to apply to Devices
    data = {}
    begin
      csv.each_with_index do |row, index|
        accounting_categories = []
        row_data = row.to_hash.merge(customer_id: @customer.id)
        logger.debug "DevicesController@#{__LINE__}#import #{row_data.inspect}" if logger.debug?

        # Check validity of the number
        # Hardcode the number, just to make sure we don't run into issues
        number = row_data['number'] = row_data['number'].try :gsub, /\D+/, ''
        (@errors['General'] ||= []) << "An entry around line #{index} has no number" and next if number.blank?
        (@errors[number] ||= []) << "Is a duplicate entry" and next if data[number]

        # Process string assingments
        row_data = Hash[row_data.map{|k, v| [k, v =~ /^="(.*?)"/ ? $1 : v] }]

        # Replace the values with the ids from lookups and Boolean
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
      logger.info "DevicesController@#{__LINE__}#import #{e.message}\n#{e.backtrace.join "\n"}"
      @errors['General'] = [e.message]
    end
    logger.debug "DevicesController@#{__LINE__}#import #{data.inspect}" if logger.debug?

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
    logger.debug "DevicesController@#{__LINE__}#import #{@errors.inspect}" if logger.debug?
    return if @errors.present?

    # Form the lists of devices to be updated and removed
    updated_devices = {}
    removed_devices = []
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

    # FIXME: Duplicated are already processed, so invalid_devices below should
    # be empty and this block of code not needed.
    number_conditions = []
    updated_devices.each do |number, device|
      device.assign_attributes(data[number])
      unless device.valid?
        logger.debug "DevicesController@#{__LINE__}#import #{data[number].inspect} #{device.errors.messages.inspect}" if logger.debug?
        @errors[number] = device.errors.full_messages
      end
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

        if clear_existing_data
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

