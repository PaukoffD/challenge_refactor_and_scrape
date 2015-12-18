# == Schema Information
#
# Table name: accounting_categories
#
#  id                 :integer          not null, primary key
#  accounting_type_id :integer
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# Model AccountingCategory
#
class AccountingCategory < ActiveRecord::Base

  belongs_to :accounting_type

  validates :name, presence: true, uniqueness: {scope: :accounting_type_id}

  scope :ordered, -> { order(:name) }

end
