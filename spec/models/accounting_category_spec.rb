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

require 'rails_helper'

describe AccountingCategory, type: :model do

  subject { create :accounting_category }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of(:name).scoped_to(:accounting_type_id)}
  it {should belong_to :accounting_type}
  it {should have_and_belong_to_many :devices}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort AccountingCategory by :ordered' do
          create :accounting_category
          create :accounting_category
          expect(AccountingCategory.ordered).to eq AccountingCategory.order(:name)
        end
      end
    end
  end

end
