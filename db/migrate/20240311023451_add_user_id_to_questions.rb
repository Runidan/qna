# frozen_string_literal: true

class AddUserIdToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :questions, :user, foreign_key: true, index: true
  end
end
