require 'rails_helper'

RSpec.describe Profile, type: :model do
  it { is_expected.to belongs_to(:user) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:user) }
end
