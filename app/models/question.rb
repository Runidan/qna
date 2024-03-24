# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user, foreign_key: :user_id

  validates :title, :body, presence: true
  validates :user, presence: true, associated: { class: User }
end
