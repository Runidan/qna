# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, foreign_key: :user_id

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, inverse_of: :answer

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true, length: { minimum: 3, maximum: 2000 }
  validates :user, presence: true, associated: { class: User }
end
