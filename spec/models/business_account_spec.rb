require 'rails_helper'

describe BusinessAccount, type: :model do

  subject { create :business_account }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort BusinessAccount by :ordered' do
          create :business_account
          create :business_account
          expect(BusinessAccount.ordered).to eq BusinessAccount.order(:name)
        end
      end
    end
  end

end
