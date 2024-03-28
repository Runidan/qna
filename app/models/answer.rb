# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, foreign_key: :user_id

  has_many_attached :files

  validates :body, presence: true, length: { minimum: 3, maximum: 2000 }
  validates :user, presence: true, associated: { class: User }
end
