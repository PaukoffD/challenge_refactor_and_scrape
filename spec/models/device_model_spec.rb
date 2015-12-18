require 'rails_helper'

describe DeviceModel, type: :model do

  subject { create :device_model }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort DeviceModel by :ordered' do
          create :device_model
          create :device_model
          expect(DeviceModel.ordered).to eq DeviceModel.order(:name)
        end
      end
    end
  end

end
