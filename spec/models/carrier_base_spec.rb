require 'rails_helper'

describe CarrierBase, type: :model do

  subject { create :carrier_base }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort CarrierBase by :ordered' do
          create :carrier_base
          create :carrier_base
          expect(CarrierBase.ordered).to eq CarrierBase.order(:name)
        end
      end
    end
  end

end
