# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', inverse_of: :profile

  validates :name, presence: true
  validates :user, presence: true, uniqueness: true

  def best_answer_rewards
    Reward.joins(question: :best_answer)
          .where(questions: { best_answer_id: user.answers.select(:id) })
  end
end
