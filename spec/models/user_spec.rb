# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to have_many(:questions) }
  it { is_expected.to have_many(:answers) }

  describe 'author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:) }
    let(:another_user) { create(:user) }
    let(:another_question) { create(:question, user: another_user) }

    it { expect(user.author_of?(question)).to be(true) }
    it { expect(user.author_of?(another_question)).to be(false) }
  end
end
