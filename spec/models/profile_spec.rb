# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile do
  it { is_expected.to belongs_to(:user) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:user) }
end
