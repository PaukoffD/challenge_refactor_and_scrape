# == Schema Information
#
# Table name: devices
#
#  id                          :integer          not null, primary key
#  number                      :string
#  customer_id                 :integer
#  device_make_id              :integer
#  device_model_id             :integer
#  status                      :string
#  imei_number                 :string
#  sim_number                  :string
#  model                       :string
#  carrier_base_id             :integer
#  business_account_id         :integer
#  contract_expiry_date        :date
#  username                    :string
#  location                    :string
#  email                       :string
#  employee_number             :string
#  contact_id                  :string
#  inactive                    :boolean
#  in_suspension               :boolean
#  is_roaming                  :boolean
#  additional_data_old         :string
#  added_features              :string
#  current_rate_plan           :string
#  data_usage_status           :string
#  transfer_to_personal_status :string
#  apple_warranty              :string
#  eligibility_date            :string
#  number_for_forwarding       :string
#  call_forwarding_status      :string
#  asset_tag                   :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  created_by                  :string
#  source                      :string
#

# Model Device
#
class Device < ActiveRecord::Base

  belongs_to :customer
  belongs_to :device_make
  belongs_to :device_model
  belongs_to :carrier_base
  belongs_to :business_account
  has_and_belongs_to_many :accounting_categories

  validates :business_account, :customer, :device_make, :number, :status, :username,
      presence: true

  scope :ordered, -> { order(:number) }

  def cancelled?
    status == 'cancelled'
  end

  def track!(attributes = {})
    assign_attributes attributes
    yield
  end

  class << self
    # Returns the list of attributes that can be seen/updted from outside
    def import_export_columns
      blacklist = %w{
        created_by
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
        source
        transfer_token
        carrier_rate_plan_id
      }
      (column_names - blacklist).reject{ |c| c =~ /_at$/ } # Reject timestamps
    end   # import_export_columns

    # Creates a Hash for the given customer that keeps the data of the customer
    # reflections so that we can quickly find the id by name
    def lookups(customer)
      @@lookups ||= {}
      lookups = (@@lookups[customer.to_param] ||= {}.with_indifferent_access)
      return lookups if lookups.present?

      import_export_columns.each do |attr|
        if attr =~ /^(\w+)_id/
          case attr
          when 'device_make_id'
            lookups[attr] = Hash[DeviceMake.pluck(:name, :id)]
          when 'device_model_id'
            lookups[attr] = Hash[DeviceModel.pluck(:name, :id)]
          else
            reflections.each do |k, reflection|
              if reflection.foreign_key == attr
                logger.debug "Device@#{__LINE__}lookups #{k}" if logger.debug?
                accessor = reflection.klass.respond_to?(:export_key) ? reflection.klass.send(:export_key) : 'name'
                method = reflection.plural_name.to_sym
                if customer.respond_to?(method)
                  lookups[attr] = Hash[customer.send(method).pluck(accessor, :id)]
                else
                  lookups[attr] = Hash[reflection.klass.pluck(accessor, :id)]
                end
              end   # if reflection.foreign_key == attr
            end   # reflections.each
          end   # case
        end   # if attr =~ /^(\w+)_id/
      end   # import_export_columns.each
      customer.accounting_types.each do |acc_type|
        lookups["accounting_categories[#{acc_type.name}]"] =
            acc_type.accounting_categories.pluck(:name, :id)
              .each_with_object({}) do |(name, id), hash|
                hash[name.strip] = id
              end
      end
      lookups
    end   # lookups

    # Looks up the headers of the kind 'accounting_categories[accounting_type]' and
    # the accounting_types met that do not belong to the customer.
    # So, if the list is empty, everything is OK.
    def check_headers(customer, headers)
      (headers.select do |header|
        header =~ /accounting_categories\[/
      end - lookups(customer).keys).map do |header|
        header.match(/accounting_categories\[(.*?)(\]|$)/)[1]
      end
    end   # check_headers

    # Takes a CSV object and creates the Hash of attributes Hashes for each
    # Device number met in the CSV where the keys are the device numbers.
    # Attributes Hases are ready to be used in assign_attributes method.
    #
    # Additionally some checks are made and if needed errors are generated.
    # The errors are placed in Hash with keys being device numbers. Unless
    # we can not tell. In the latter case the key 'General' is used.
    #
    # The method returns pair of the Hashes.
    def parse(csv, customer)
      data = {}
      errors  = {}
      lookups = self.lookups customer
      index = 1
      csv.each do |row|
        index += 1
        accounting_categories = []
        row_data = row.to_hash.merge(customer_id: customer.to_param)
        logger.debug "Device@#{__LINE__}#parse #{row_data.inspect}" if logger.debug?

        # Check validity of the number
        # Hardcode the number, just to make sure we don't run into issues
        number = row_data['number'] = row_data['number'].try :gsub, /\D+/, ''
        (errors['General'] ||= []) << [:no_number, index] and next if number.blank?
        (errors[number] ||= []) << [:duplicate, index] and next if data[number]

        # Process string assingments
        row_data = Hash[row_data.map{|k, v| [k, v =~ /^="(.*?)"/ ? $1 : v] }]

        # Replace the values with the ids from lookups and Boolean
        row_data.keys.each do |attr|
          next if attr.blank?
          value = row_data[attr]
          if lookups.key? attr
            if attr =~ /accounting_categories/
              accounting_type = attr.gsub(/accounting_categories\[(.*?)\]/, '\1')
              val = lookups[attr][value.to_s.strip]
              if !val
                # Why not to create a new accounting_type?
                (errors[number] ||= []) <<
                    [:unknown_accounting_category, index, accounting_type, value]
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
        data[number] = row_data
      end

      # Duplicated_numbers
      where(number: data.keys)
        .where.not(customer_id: customer.to_param)
        .where.not(status: 'cancelled')
      .each do |device|
        if data[device.number]['status'] != 'cancelled'
          (errors[device.number] ||= []) << [:existing_device]
        end
      end

      logger.debug "Device@#{__LINE__}#parse #{errors.inspect}" if logger.debug? and errors.present?
      [data, errors]
    rescue => e
      logger.info "Device@#{__LINE__}#parse #{e.message.inspect}\n#{e.backtrace.join "\n"}"
      [data, {errors: {'General' => e.message}}]
    end   # parse

    # Takes a CSV object, parses it and if no errors are met and
    # all the Device attributes produce the valid Devices, updates
    # and/or adds new ones to the customer devices list.
    # If clear_existing_data is not falsy the customer Devices
    # that did not apper in the CSV will be discarded.
    #
    # Each Device touched will keep the reference to the
    # current_user that initialized the operation.
    #
    # Returns number of updated/added rerords and number of deleted ones if
    # no errors took place, otherwise returns the Hash of errors.
    def import(csv, customer, clear_existing_data, current_user)
      data, errors = parse csv, customer
      return errors if errors.present?

      # Form the lists of devices to be updated and removed
      updated_devices = {}
      removed_devices = []
      customer.devices.each do |device|
        if data.has_key?(device.number)
          updated_devices[device.number] = device
        elsif clear_existing_data
          removed_devices << device
        end
      end
      data.each do |number, attributes|
        updated_devices[number] = Device.new unless updated_devices[number]
      end

      # Assign attributes and check validity
      updated_devices.each do |number, device|
        device.assign_attributes(data[number])
        errors[number] = device.errors.full_messages unless device.valid?
      end

      return errors if errors.present?

      # Let us save the work
      transaction do
        updated_devices.each do |number, device|
          device.track!(created_by: current_user, source: "Bulk Import") do
            device.save(validate: false)
          end
        end

        if clear_existing_data
          removed_devices.each{ |device| device.delete }
        end

      end   # Device.transaction
      [updated_devices.size, removed_devices.size]
    end   # import
  end   # class << self
end
