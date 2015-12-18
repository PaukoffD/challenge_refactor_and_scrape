# Model AccountingType defines ... TODO:
#
class AccountingType < ActiveRecord::Base

  belongs_to :customer

  validates :name, presence: true, uniqueness: {scope: :customer_id}

  scope :ordered, -> { order(:name) }

end
