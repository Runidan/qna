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

  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for :links }

  it 'have many atteches file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
