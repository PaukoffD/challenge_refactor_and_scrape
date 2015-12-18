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

require 'rails_helper'

describe AccountingType, type: :model do

  subject { create :accounting_type }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of(:name).scoped_to(:customer_id)}
  it {should belong_to :customer}
  it {should have_many :accounting_categories}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort AccountingType by :ordered' do
          create :accounting_type
          create :accounting_type
          expect(AccountingType.ordered).to eq AccountingType.order(:name)
        end
      end
    end
  end

end
