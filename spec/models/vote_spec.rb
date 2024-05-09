# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:vote) { create(:vote, votable: question, user:) }

  describe 'associations' do
    it { is_expected.to belong_to(:votable) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:votable) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }
  end
end
