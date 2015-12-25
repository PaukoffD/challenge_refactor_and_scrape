require 'rails_helper'

describe CheckDelivery, type: :model do

  subject { build :check_delivery }

  it { should be_valid }
  it {should validate_presence_of :delivery_company_id}
  it {should validate_presence_of :query}

  it {should belong_to :delivery_company}

  describe :class do
    describe '.column_names' do
      it 'returns %w[delivery_company_id query]' do
        expect(CheckDelivery.column_names).to eq %w[delivery_company_id query]
      end
    end   # column_names
  end   # class
end
