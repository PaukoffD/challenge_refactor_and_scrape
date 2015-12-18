# == Schema Information
#
# Table name: business_accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Model BusinessAccount
#
class BusinessAccount < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

end
