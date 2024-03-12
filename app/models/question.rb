# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :user, presence: true, associated: { class: User }

  def permit?(user)
    self.user == user
  end
end
