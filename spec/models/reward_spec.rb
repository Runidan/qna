# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward do
  it { is_expected.to belong_to(:question).with_foreign_key('question_id').inverse_of(:reward) }
  it { is_expected.to belong_to(:answer).with_foreign_key('answer_id').inverse_of(:reward).optional }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_one_attached(:image) }
  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpeg') }
end
