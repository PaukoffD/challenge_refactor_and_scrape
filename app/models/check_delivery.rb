# Model CheckDelivery defines model to keep request paramters to pull DeliveryCompany
#
class CheckDelivery
  include ActiveModel::Model
  include ActiveModel::Associations

  attr_accessor :delivery_company_id, :query

  validates :delivery_company_id, :query, presence: true

  belongs_to :delivery_company

  # need hash like accessor, used internal Rails
  def [](attr)
    self.send(attr)
  end

  # need hash like accessor, used internal Rails
  def []=(attr, value)
    self.send("#{attr}=", value)
  end

  class << self
    def column_names
      %w[delivery_company_id query]
    end
  end
end
