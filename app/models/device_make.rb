# Model DeviceMake
#
class DeviceMake < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
