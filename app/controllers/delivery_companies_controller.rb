class DeliveryCompaniesController < InheritedResources::Base

  private

    def delivery_company_params
      params.require(:delivery_company).permit(:name, :url, :form_name, :form_action, :field_name, :extra_fields, :extra_values, :submit, :xpath, :css)
    end
end

