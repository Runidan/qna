# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_db_column(:body).of_type(:text) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(3) }
  it { is_expected.to validate_length_of(:body).is_at_most(2000) }
end
