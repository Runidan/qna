# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question, foreign_key: 'question_id', inverse_of: :reward
  belongs_to :answer, foreign_key: 'answer_id', optional: true, inverse_of: :reward

  has_one_attached :image

  validates :name, presence: true
  validates :image, attached: true, content_type: ['image/png', 'image/jpeg']
end
