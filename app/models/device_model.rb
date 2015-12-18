# Model DeviceModel defines ... TODO:
#
class DeviceModel < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
