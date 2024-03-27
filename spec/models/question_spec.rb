# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_db_column(:body).of_type(:text) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_numericality_of(:best_answer_id).only_integer.allow_nil }

  it "have many atteches file" do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many) 
  end
  
end
