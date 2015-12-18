# == Schema Information
#
# Table name: business_accounts
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#

# Model BusinessAccount
#
class BusinessAccount < ActiveRecord::Base

  belongs_to :customer

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
