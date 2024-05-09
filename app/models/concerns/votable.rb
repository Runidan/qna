# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def vote_up_by(user)
      vote(user, 1)
    end

    def vote_down_by(user)
      vote(user, -1)
    end

    def rating
      votes.sum(:value)
    end

    private

    def vote(user, value)
      vote = votes.find_or_initialize_by(user:)
      vote.update(value:) if vote.changed?
    end
  end
end
