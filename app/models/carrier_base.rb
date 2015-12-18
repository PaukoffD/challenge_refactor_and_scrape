# Model CarrierBase defines ... TODO:
#
class CarrierBase < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
