json.array!(@delivery_companies) do |delivery_company|
  json.extract! delivery_company, :id, :name, :url, :form_name, :form_action, :field_name, :extra_fields, :extra_values, :submit, :xpath, :css
  json.item_url delivery_company_url(delivery_company, format: :json)
end
