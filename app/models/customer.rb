# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Model Customer
#
class Customer < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  has_many :accounting_types
  has_many :business_accounts

  scope :ordered, -> { order(:name) }

end
