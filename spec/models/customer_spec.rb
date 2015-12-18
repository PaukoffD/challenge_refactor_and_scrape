# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Customer, type: :model do

  subject { create :customer }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}
  it {should have_many :accounting_types}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort Customer by :ordered' do
          create :customer
          create :customer
          expect(Customer.ordered).to eq Customer.order(:name)
        end
      end
    end
  end

end
