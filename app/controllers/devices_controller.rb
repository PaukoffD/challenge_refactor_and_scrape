class DevicesController < InheritedResources::Base

  respond_to :html, :json

  private

    def device_params
      params.require(:device).permit(:number, :customer_id, :device_make_id, :device_model_id, :status, :imei_number, :sim_number, :model, :carrier_base_id, :business_account_id, :contract_expiry_date, :username, :location, :email, :employee_number, :contact_id, :inactive, :in_suspension, :is_roaming, :additional_data_old, :added_features, :current_rate_plan, :data_usage_status, :transfer_to_personal_status, :apple_warranty, :eligibility_date, :number_for_forwarding, :call_forwarding_status, :asset_tag)
    end
end

