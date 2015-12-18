# Model Customer
#
class Customer < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  has_many :accounting_types

  scope :ordered, -> { order(:name) }

end
