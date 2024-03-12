# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 3, maximum: 2000 }
  validates :user, presence: true, associated: { class: User }

  def permit?(user)
    self.user == user
  end
end
