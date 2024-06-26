# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions
  has_many :answers

  def author_of?(object)
    id == object.user_id
  end

  def best_answer_rewards
    Reward.joins(question: :best_answer)
          .where(questions: { best_answer_id: answers.select(:id) })
  end
end
