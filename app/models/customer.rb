# Model Customer defines ... TODO:
#
class Customer < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
