# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions
  has_many :answers
  has_one :profile, dependent: :destroy, inverse_of: :user

  after_create :build_default_profile

  def author_of?(object)
    id == object.user_id
  end

  def best_answer_rewards
    Reward.joins(question: :best_answer)
          .where(questions: { best_answer_id: user.answers.select(:id) })
  end

  private

  def build_default_profile
    user_name = email.split('@')[0]
    build_profile(name: user_name).save
  end
end
