require 'csv'

class DevicesController < InheritedResources::Base

  respond_to :html, :json
  belongs_to :customer, shallow: true

  def import
    @customer = Customer.find params[:customer_id]
    @warnings = []

    if @customer.devices.count(:all) == 0
      @warnings << t('.warning_no_devices')
    end
    if @customer.business_accounts.count(:all) == 0
      @warnings << t('.warning_no_accounts')
    end

    return unless request.post?   # Old good rails v.1.0 style ;-)

    import_file = params[:import_file]
    return flash[:error] = t('.please_upload') if import_file.blank?
    clear_existing_data = params[:clear_existing_data]

    # We need this in a string since we parse it twice and Ruby will
    # automatically close and GC it if we don't
    contents = import_file.tempfile.read.encode(invalid: :replace, replace: '')
    csv = CSV.parse(contents, headers: true, encoding: 'UTF-8')
    return @errors = {'General' => t('.not_csv')} unless csv.is_a? CSV::Table
    return @errors = {'General' => t('.not_row')} unless csv.first.is_a? CSV::Row

    # Check that headers have only existing accounting_types
    unknown = Device.check_headers @customer, csv.headers
    return @errors = {'General' => missing_types_errors(unknown)} if unknown.present?

    result = Device.import csv, @customer, clear_existing_data, current_user
    if result.is_a? Hash
      @errors = result
      @errors.values.each {|error| translate_error!(error)}
    else
      flash[:notice] = [
        t('.success'),
        t('.updated', count: result.first),
        t('.removed', count: result.second)
      ].join(' ')
    end
  end   # import

  private

  def device_params
    params.require(:device).permit(:number, :customer_id, :device_make_id, :device_model_id, :status, :imei_number, :sim_number, :model, :carrier_base_id, :business_account_id, :contract_expiry_date, :username, :location, :email, :employee_number, :contact_id, :inactive, :in_suspension, :is_roaming, :additional_data_old, :added_features, :current_rate_plan, :data_usage_status, :transfer_to_personal_status, :apple_warranty, :eligibility_date, :number_for_forwarding, :call_forwarding_status, :asset_tag)
  end

  # For erorr that is an Arrray with leading Symbol substitutes
  # it with the corresponding translation.
  def translate_error!(error)
    error.map! do |code, line, value1, value2|
      if code.is_a? Symbol
        t ".#{code}", line: line, value1: value1, value2: value2
      else
        code
      end
    end
  end

  # Tranlates the given list into the corresponding eroor messages
  def missing_types_errors(unknown)
    unknown.map do |header|
      t '.unknown_accounting_type', name: header
    end
  end
end

