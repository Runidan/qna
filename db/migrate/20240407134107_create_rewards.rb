# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.references :question, foreign_key: true, null: false
      t.references :answer, foreign_key: true
      t.timestamps
    end
  end
end
