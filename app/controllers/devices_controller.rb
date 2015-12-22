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

    import_file = params[:import_file]
    return flash[:error] = 'Please upload a file to be imported' if import_file.blank?
    clear_existing_data = params[:clear_existing_data]

    # We need this in a string since we parse it twice and Ruby will
    # automatically close and GC it if we don't
    contents = import_file.tempfile.read.encode(invalid: :replace, replace: '')
    csv = CSV.parse(contents, headers: true, encoding: 'UTF-8')
    return @errors = {'General' => t('.not_csv')} unless csv.is_a? CSV::Table
    return @errors = {'General' => t('.not_row')} unless csv.first.is_a? CSV::Row

    # Check that headers have only existing accounting_types
    unknown = Device.check_headers @customer, csv.headers
    return @errors = {'General' => unknown.map do |header|
                        t '.unknown_accounting_type', name: header
                      end} if unknown.present?

    # Prepare the data Hash to apply to Devices
    data, @errors = Device.parse csv, @customer

    # Shortcut here to get basic errors out of the way
    logger.debug "DevicesController@#{__LINE__}#import #{@errors.inspect}" if logger.debug?
    return @errors.values.each do |error|
      error.map! do |code, line, value1, value2|
        t ".#{code}", line: line, value1: value1, value2: value2
      end
    end if @errors.present?

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
    @errors = {}
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

