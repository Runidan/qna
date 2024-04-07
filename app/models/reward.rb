class Reward < ApplicationRecord
  belongs_to :question, foreign_key: "question_id"
  belongs_to :answer, foreign_key: "answer_id", optional: true

  has_one_attached :image

  validates :name,presence: true
end
