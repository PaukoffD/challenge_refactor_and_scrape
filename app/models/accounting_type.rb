# == Schema Information
#
# Table name: accounting_types
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Model AccountingType
#
class AccountingType < ActiveRecord::Base

  belongs_to :customer
  has_many :accounting_categories

  validates :name, presence: true, uniqueness: {scope: :customer_id}

  scope :ordered, -> { order(:name) }

end
