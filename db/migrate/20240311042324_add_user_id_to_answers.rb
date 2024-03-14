# frozen_string_literal: true

class AddUserIdToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :user, foreign_key: true, index: true
  end
end
