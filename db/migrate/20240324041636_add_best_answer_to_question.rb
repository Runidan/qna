# frozen_string_literal: true

class AddBestAnswerToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :best_answer_id, :integer
    add_index :questions, :best_answer_id
    add_foreign_key :questions, :answers, column: :best_answer_id, on_delete: :cascade
  end
end
