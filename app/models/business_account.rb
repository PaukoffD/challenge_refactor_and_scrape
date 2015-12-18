# Model BusinessAccount defines ... TODO:
#
class BusinessAccount < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
