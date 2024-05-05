class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user, foreign_key: :user_id

  validates :votable, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
end
