# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user, foreign_key: :user_id

  has_many_attached :files

  validates :title, :body, presence: true
  validates :user, presence: true, associated: { class: User }
  validates :best_answer_id, numericality: { only_integer: true, allow_nil: true }
end
