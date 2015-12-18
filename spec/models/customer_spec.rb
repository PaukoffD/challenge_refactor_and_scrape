require 'rails_helper'

describe Customer, type: :model do

  subject { create :customer }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

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
