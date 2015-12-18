# == Schema Information
#
# Table name: device_makes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe DeviceMake, type: :model do

  subject { create :device_make }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sorts DeviceMake by :ordered' do
          create :device_make
          create :device_make
          expect(DeviceMake.ordered).to eq DeviceMake.order(:name)
        end
      end
    end
  end

end
