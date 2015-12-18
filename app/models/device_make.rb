# == Schema Information
#
# Table name: device_makes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Model DeviceMake
#
class DeviceMake < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
